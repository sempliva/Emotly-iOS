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

import XCTest
@testable import emotly

class LoginViewControllerTests: XCTestCase {
    var viewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        viewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
    }
    
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewController() {
        // Test and Load the View at the Same Time!
        XCTAssertNotNil(viewController.view)
    }

    func testLogin() {
        let emotlyAPIManagerTest = EmotlyAPIManagerTest()
        let login_params : NSDictionary = ["user_id": "test", "password": "password"]
        
        (viewController as! LoginViewController).login(login_params, restApiService: emotlyAPIManagerTest)
        
        // Test that the RestApiManager was actually called
        XCTAssertTrue(emotlyAPIManagerTest.postOperationWasCalled)
        
        let prefs = NSUserDefaults.standardUserDefaults()
        let login = prefs.integerForKey("ISLOGGEDIN") as Int
        let nickname = prefs.objectForKey("NICKNAME") as! String
        let jwt = prefs.objectForKey("JWT") as! NSDictionary
        
        XCTAssertEqual(jwt.allKeys.count, 3)
        XCTAssertEqual(nickname, "test")
        XCTAssertEqual(login, 1)
    }
}
