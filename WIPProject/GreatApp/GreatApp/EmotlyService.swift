//
//  EmotlyService.swift
//  GreatApp
//
//  Created by Michelangelo De Simone on 6/22/16.
//  Copyright © 2016 Michelangelo De Simone. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// An Emotly.
struct Emotly {
    let created_at: NSDate?
    let mood: String?
    let nickname: String?
}

/// A list of Emotly.
typealias Emotlies = [Emotly] // TODO: Order on the fly?

/// A utility type.
struct EmotlyUtils {
    static func convertDateFromString(dateString: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.dateFromString(dateString)
    }
}

/// The Emotly JWT.
struct EmotlyJWT {
    private let rawJSON: JSON

    init(_ rawJson: JSON) {
        self.rawJSON = rawJson
    }
    
    var signature: String {
        return rawJSON["signature"].stringValue
    }
    
    var payload: [String: JSON] {
        return rawJSON["payload"].dictionaryValue
    }
    
    var header: [String: JSON] {
        return rawJSON["header"].dictionaryValue
    }

    var nickname: String {
        guard let nickname = payload["nickname"] else { return "" }
        return nickname.stringValue
    }
    
    var expirationDate: NSDate? {
        guard let expire = payload["expire"] else { return nil }
        return EmotlyUtils.convertDateFromString(expire.stringValue)
    }

    func isOfType(type:  Type) -> Bool {
        guard let hdr = header["type"] else {
            return false
        }
        
        let strType = hdr.stringValue
        switch type {
        case .JWT:
            return strType == "jwt"
        default:
            return false
        }
    }

    func isUsingAlgo(algo: AlgoType) -> Bool {
        guard let hdr = header["algo"] else {
            return false
        }
        
        let strAlgoType = hdr.stringValue
        switch algo {
        case .SHA256:
            return strAlgoType == "sha256"
        default:
            return false
        }
    }

    /// Returns whether this JWT is locally valid.
    var isValid: Bool {
        if !isUsingAlgo(.SHA256) { return false }
        if !isOfType(.JWT) { return false }
        if nickname.isEmpty { return false }
        guard let expDate = expirationDate else { return false }
        if NSDate().compare(expDate) != .OrderedAscending { return false }
        
        return true
    }

    enum Type {
        case JWT
        case UNKNOWN
    }
    
    enum AlgoType {
        case SHA256
        case UNKNOWN
    }
}

/**

 A representation of the Emotly service; exposes all the methods available on
 the backend.
 */
class EmotlyService {
    private var emotlies: Emotlies = []
    private static let emotlyURL = "https://emotly.herokuapp.com/api/1.0"
    private var jwt: EmotlyJWT?

    /**
 
    Attempt to login with the given credentials.

    - Parameters:
        - username: user's username or email
        - password: user's password
        - doneCallback: the handler to be called when the operation ends.
        If the user has succesfully authenticated, the `Bool` parameter would
        be true, false otherwise.
    */
    func login(username: String, password: String, doneCallback: (Bool, NSError?) -> Void) {
        let credentials = [ "user_id" : username, "password" : password]
        let endpoint = EmotlyService.emotlyURL + "/login"
        let req = Alamofire.request(.POST, endpoint, parameters: credentials, encoding: .JSON)
        req.validate().response { request, response, data, error in
            guard  error == nil else {
                doneCallback(false, error)
                return
            }

            guard let dat = data else {
                doneCallback(false, error)
                return
            }

            let json_response = JSON(data: dat)
            self.jwt = EmotlyJWT(json_response)
            doneCallback(self.jwt!.isValid, nil)
        }

        // TODO: Deal with the non-valid requests here.
    }

    /**

     Issue a request to update (refresh) the emotlies.

     - Parameters:
         - doneCallback: The handler to be called when the operation ends.
     */
    func updateEmotlies(doneCallback: (Emotlies?, NSError?) -> Void) {

        let endpoint = EmotlyService.emotlyURL + "/emotlies"
        let req = Alamofire.request(.GET, endpoint)
        req.validate().response { request, response, data, error in
            guard  error == nil else {
                doneCallback(nil, error)
                return
            }

            guard let dat = data else {
                doneCallback(nil, error)
                return
            }
            
            let json_dat = JSON(data: dat)

            for (_, subjson): (String, JSON) in json_dat["emotlies"] {
                if let newEmotly = self.createEmotlyFromJSON(subjson) {
                    self.emotlies.append(newEmotly)
                }
            }

            // TODO: Order the self.emotlies before calling doneCallback.
            doneCallback(self.emotlies, nil)
        }
    }
    
    private func createEmotlyFromJSON(emotlyJson: JSON) -> Emotly? {
        let mood = emotlyJson["mood"].stringValue
        let nickname = emotlyJson["nickname"].stringValue
        let str_created_at = emotlyJson["created_at"].stringValue
        let created_at = EmotlyUtils.convertDateFromString(str_created_at)

        return Emotly(created_at: created_at, mood: mood, nickname: nickname)
    }
}