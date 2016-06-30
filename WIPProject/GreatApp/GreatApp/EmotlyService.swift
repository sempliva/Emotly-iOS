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

/**

 A representation of the Emotly service; exposes all the methods available on
 the backend.
 */
class EmotlyService {

    /// Initializes the EmotlyService.
    init() {
        dtf.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    }

    /**

     Issue a request to update (refresh) the emotlies.

     - Parameters:
     - doneCallback: The handler to be called when the operation finishes.
     */
    func updateEmotlies(doneCallback: (Emotlies?, NSError?) -> Void) {

        let endpoint = EmotlyService.emotlyURL + "/emotlies"
        let req = Alamofire.request(.GET, endpoint)
        req.validate().response { request, response, data, error in
            if let dat = data {
                let json_dat = JSON(data: dat)

                for (_, subjson): (String, JSON) in json_dat["emotlies"] {
                    if let newEmotly = self.createEmotlyFromJSON(subjson) {
                        self.emotlies.append(newEmotly)
                    }
                }

                // TODO: Order the self.emotlies before calling doneCallback.
                doneCallback(self.emotlies, nil)
            }
            // TODO: deal with the error here. Returning (nil, error) should be ok.
        }
    }
    
    private func createEmotlyFromJSON(emotlyJson: JSON) -> Emotly? {
        let mood = emotlyJson["mood"].stringValue
        let nickname = emotlyJson["nickname"].stringValue
        let str_created_at = emotlyJson["created_at"].stringValue
        let created_at = self.dtf.dateFromString(str_created_at)

        return Emotly(created_at: created_at, mood: mood, nickname: nickname)
    }

    private var emotlies: Emotlies = []
    private let dtf = NSDateFormatter()
    private static let emotlyURL = "https://emotly.herokuapp.com/api/1.0"
}