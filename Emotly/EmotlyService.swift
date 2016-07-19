/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2016 Emotly Contributors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import Foundation
import Alamofire
import SwiftyJSON
import Pantry

/// An Emotly.
struct Emotly {
    let created_at: NSDate?
    let mood: String? // We store the mood as plain String because we
                      // don't need its id here.
    let nickname: String?

}

/// A Mood.
struct Mood {
    private let rawJSON: JSON
    var value: String? { return rawJSON["value"].stringValue }
    var id: UInt { return rawJSON["id"].uIntValue }

    init(_ rawJSON: JSON) {
        self.rawJSON = rawJSON
    }
}

/// A list of Emotly.
typealias Emotlies = [Emotly] // TODO: Order on the fly?

/// A list of Mood.
typealias Moods = [Mood] // TODO: This should be ordered on the fly too.

/// A utility type.
struct EmotlyUtils {
    static let EMOTLY_JWT = "EmotlyJWT"
    static let EMOTLY_JWT_KEY = "EmotlyJWT_JSON_AsString"

    static func convertDateFromString(dateString: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.dateFromString(dateString)
    }
}

/// The Emotly JWT.
struct EmotlyJWT: Storable {
    private let rawJSON: JSON

    init(_ rawJson: JSON) {
        self.rawJSON = rawJson
    }

    init(warehouse: JSONWarehouse) {
        let wareString = warehouse.get(EmotlyUtils.EMOTLY_JWT_KEY) ?? ""
        self.rawJSON = JSON.parse(wareString)
    }
    
    func toDictionary() -> [String : AnyObject] {
        return [EmotlyUtils.EMOTLY_JWT_KEY : rawJSON.rawString()!]
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

    /// Raw, un-pretty, String representation of the JWT.
    var uglyString: String {
        return rawJSON.rawString(NSUTF8StringEncoding,
                                 options: NSJSONWritingOptions(rawValue: 0)) ?? ""
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

 *DO NOT INSTANTIATE THIS CLASS DIRECTLY*, use the `sharedService` property
 instead.
 */
class EmotlyService {
    private static let emotlyURL = "https://emotly.herokuapp.com/api/1.0"
    private(set) var emotlies: Emotlies = []
    private(set) var moods: Moods = []

    static let sharedService = EmotlyService()

    // The internal JWT. Consumers should use getJWT().
    private var jwt: EmotlyJWT? {
        didSet {
            if let jwt = self.jwt {
                // Persistence of JWT object into Pantry with expiration date.
                let jwtExpDate = StorageExpiry.Date((jwt.expirationDate)!)
                Pantry.pack(jwt, key: EmotlyUtils.EMOTLY_JWT, expires: jwtExpDate)
            }
            // Remove JWT from Pantry (execute logout).
            else { Pantry.expire(EmotlyUtils.EMOTLY_JWT) }
        }
    }

    private init() {} // EmotlyService is a singleton object: enforcing.

    /**

     Check if JWT is valid.

     - Parameters:
     - doneCallback: the handler to be called when the operation ends.
     If the jwt is valid, the `Bool` parameter would be true, false otherwise.
     */
    func is_jwt_valid(doneCallback: (Bool, NSError?) -> Void) {
        let endpoint = EmotlyService.emotlyURL + "/is_jwt_valid"
        let req = Alamofire.request(.POST, endpoint, encoding: .JSON,
                                    headers: reqHeaders())
        req.validate().response { request, response, data, error in
            guard error == nil else {
                doneCallback(false, error)
                return
            }
            doneCallback(true, nil)
        }
        // TODO: Deal with the non-valid requests here.
    }

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
            guard error == nil else {
                doneCallback(false, error)
                return
            }

            guard let dat = data else {
                // TODO: Customize the error here.
                doneCallback(false, error)
                return
            }

            let json_response = JSON(data: dat)
            let tempJWT = EmotlyJWT(json_response)
            let isValid = tempJWT.isValid

            if isValid { self.jwt = tempJWT }
            doneCallback(isValid, nil)
        }

        // TODO: Deal with the non-valid requests here.
    }

    /**

     Issues a request to post a new Emotly with the specified mood.

     - Parameters:
        - id: the id of the mood
        - doneCallback: The handler to be called when the operation ends.
     */
    func postEmotlyWithMood(id: UInt, doneCallback: (Emotly?, NSError?) -> Void) {
        guard jwt != nil else {
            doneCallback(nil, nil) // TODO: We need a custom error here.
            return
        }

        let endpoint = EmotlyService.emotlyURL + "/emotlies/new"
        let newEmotly = ["mood" : id]

        let req = Alamofire.request(.POST, endpoint, encoding: .JSON,
                                    headers: reqHeaders(),
                                    parameters: newEmotly)
        req.validate().response { request, response, data, error in
            guard error == nil else {
                doneCallback(nil, error)
                return
            }

            guard let dat = data else {
                // TODO: Customize the error here.
                doneCallback(nil, error)
                return
            }

            // If everything has worked out, we create a new Emotly and we
            // append it to our internal list.
            let subjson = JSON(data: dat)
            guard let newEmotly = self.createEmotlyFromJSON(subjson["emotly"]) else {
                // TODO: We need to return an appropriate (proprietary) error
                // because the request hasn't failed but the parsing of the
                // Emotly has. Tip: subclass NSError and create EmotlyError.
                doneCallback(nil, nil)
                return
            }
            self.emotlies.append(newEmotly)
            doneCallback(newEmotly, nil)
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
                // TODO: Customize the error here.
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

    /**

    Refresh the internal list of moods; this operation is required before
    being able to post a new Emotly.

    - Parameters:
        - doneCallback: The handler to be called when the operation ends.
    */
    func updateMoods(doneCallback: (NSError?) -> Void) {

        let endpoint = EmotlyService.emotlyURL + "/moods"
        let req = Alamofire.request(.GET, endpoint)
        req.validate().response { request, response, data, error in
            guard error == nil else {
                doneCallback(error)
                return
            }

            guard let dat = data else {
                // TODO: Customize the error here.
                return
            }

            let json_dat = JSON(data: dat)
            for (_, subjson): (String, JSON) in json_dat["moods"] {
                self.moods.append(Mood(subjson))
            }

            doneCallback(nil)
        }
    }

    /// Returns the current JWT, if available.
    func getJWT() -> EmotlyJWT? {
        if let jwt = self.jwt { return jwt }
        if let jwt: EmotlyJWT = Pantry.unpack(EmotlyUtils.EMOTLY_JWT) {
            self.jwt = jwt
        }
        return self.jwt
    }

    /// Used to get prepopulated HTTP headers (incl. the auth info).
    private  func reqHeaders() -> [String : String] {
        return ["X-Emotly-Auth-Token" : getJWT()!.uglyString]
    }

    private func createEmotlyFromJSON(emotlyJson: JSON) -> Emotly? {
        let mood = emotlyJson["mood"].stringValue
        let nickname = emotlyJson["nickname"].stringValue
        let str_created_at = emotlyJson["created_at"].stringValue
        let created_at = EmotlyUtils.convertDateFromString(str_created_at)

        return Emotly(created_at: created_at, mood: mood, nickname: nickname)
    }
}
