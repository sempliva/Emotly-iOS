//
//  EmotlyService.swift
//  GreatApp
//
//  Created by Michelangelo De Simone on 6/22/16.
//  Copyright © 2016 Michelangelo De Simone. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Emotly {
    let created_at: NSDate?
    let mood: String?
    let nickname: String?
}

typealias Emotlies = [Emotly] // TODO: Order on the fly

class EmotlyService {
    private var emotlies: Emotlies = []
    private let ses = NSURLSession.sharedSession()
    private let dtf = NSDateFormatter()
    
    init() {
        dtf.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    }
    
    // doneCallback will be called on the main thread.
    func updateEmotlies(doneCallback: (Emotlies?, NSError?) -> Void) {

        let endpoint = EmotlyService.emotlyURL + "/emotlies"
        let req = NSURLRequest(URL: NSURL(string: endpoint)!)

        let tsk = ses.dataTaskWithRequest(req, completionHandler: { (d, r, e) in
            if let dat = d {
                let json_dat = JSON(data: dat)

                for (_, subjson): (String, JSON) in json_dat["emotlies"] {
                    let mood = subjson["mood"].stringValue
                    let nickname = subjson["nickname"].stringValue
                    let str_created_at = subjson["created_at"].stringValue
                    let created_at = self.dtf.dateFromString(str_created_at)
                    
                    self.emotlies.append(Emotly(created_at: created_at,
                        mood: mood, nickname: nickname))
                    
                }
                dispatch_async(dispatch_get_main_queue(), { doneCallback(self.emotlies, nil) })
            }
            
            // Deal with error.
        })

        tsk.resume()
    }
    
    private static let emotlyURL = "https://emotly.herokuapp.com/api/1.0"
}