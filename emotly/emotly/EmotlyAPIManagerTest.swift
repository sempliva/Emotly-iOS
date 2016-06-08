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

// This class implement the protocol to get access to the REST API in a test environment.
class EmotlyAPIManagerTest: EmotlyAPIManagerAbstract {
    var getOperationWasCalled = false
    var emotlies = [Emotly]()
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func getOperation(path: String, onCompletion: (NSDictionary) -> Void) {
        getOperationWasCalled = true
        let route = Constant.RESTAPI.BaseURL + path
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as NSDictionary)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let jsonData = "{\"emotlies\": [{\"created_at\": \"2016-05-18T17:06:02Z\",\"mood\": \"buh\",\"nickname\": \"testgetown\"},{\"created_at\": \"2016-05-19T17:06:02Z\",\"mood\": \"happy\",\"nickname\": \"testgetown2\"}]}"
        let result =  convertStringToDictionary(jsonData)!
        onCompletion(result, nil)
    }
    
}
