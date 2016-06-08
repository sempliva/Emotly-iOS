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

class EmotlyTableViewControllerTests: XCTestCase {
    var viewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        viewController = storyboard.instantiateViewControllerWithIdentifier("EmotlyTableViewController") as! EmotlyTableViewController
    }
    
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewController() {
        // Test and Load the View at the Same Time!
        XCTAssertNotNil(viewController.view)
    }
    
    func test_fetchEmotlies() {
        let emotlyAPIManagerTest = EmotlyAPIManagerTest()
        
        (viewController as! EmotlyTableViewController).getEmotlies(emotlyAPIManagerTest)
        
        // Test that the RestApiManager was actually called
        XCTAssertTrue(emotlyAPIManagerTest.getOperationWasCalled)
        
        // Test that our injected result was assigned
        // to the emotlies array
        XCTAssertEqual((viewController as! EmotlyTableViewController).emotlies.count, 2)
        print((viewController as! EmotlyTableViewController).emotlies.count)
        XCTAssertGreaterThan( (viewController as! EmotlyTableViewController).emotlies[1].created_at.timeIntervalSinceReferenceDate,
                              (viewController as! EmotlyTableViewController).emotlies[0].created_at.timeIntervalSinceReferenceDate)
    }
}
