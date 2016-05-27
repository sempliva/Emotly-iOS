/*
 MIT License
 Copyright (c) 2016 Emotly Contributors
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

// This class implement the protocol to get access to the REST API.
class EmotlyAPIManager: NSObject, EmotlyAPIManagerAbstract {
    
    func getOperation(path: String, onCompletion: (NSDictionary) -> Void) {
        let route = Constant.RESTAPI.BaseURL + path
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as NSDictionary)
        })
    }
    
    func postOperation(path: String, bodyParam: NSDictionary,  onCompletion: (NSDictionary) -> Void) {
        let route = Constant.RESTAPI.BaseURL + path
        makeHTTPpostRequest(route, bodyParam: bodyParam, onCompletion: { json, err in
            onCompletion(json as NSDictionary)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: path)!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    onCompletion(jsonResult, error)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func makeHTTPpostRequest(path: String, bodyParam: NSDictionary, onCompletion: ServiceResponse) {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: path)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-Type")

        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(bodyParam, options: [])
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    onCompletion(jsonResult, error)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
