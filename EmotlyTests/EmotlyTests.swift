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

import XCTest
@testable import Emotly

class EmotlyTests: XCTestCase {
    private let emoServ: EmotlyService = EmotlyService.sharedService
    private let TIMEOUT = 20.0
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testStub() {
        XCTAssertTrue(true)
    }

    // TODO: Provide test credentials to enable this test.
//    func testLibEmotlyLoginWithRightCredentials() {
//        let exp = expectationWithDescription("Expected login to succeeded")
//
//        emoServ.login("TESTUSERNAMEHERE", password: "michelangelo") { (suc, err) in
//            XCTAssertTrue(suc)
//            XCTAssertNil(err)
//            exp.fulfill()
//        }
//
//        waitForExpectationsWithTimeout(TIMEOUT, handler: nil)
//    }

    func testLibEmotlyLoginWrongCredentials() {
        let exp = expectationWithDescription("Expected login to fail")

        emoServ.login("FAKEUSERNAME", password: "FAKEPWD") { (suc, err) in
            XCTAssertFalse(suc)
            XCTAssertNotNil(err)

            exp.fulfill()
        }

        waitForExpectationsWithTimeout(TIMEOUT, handler: nil)
    }

    func testLibEmotlyListEmotliesExist() {
        let exp = expectationWithDescription("Expected list of emotlies")

        emoServ.updateEmotlies { (emotlies, error) in
            guard let e = emotlies else {
                XCTFail()
                return
            }

            XCTAssertNil(error)
            XCTAssertGreaterThan(e.count, 0)
            exp.fulfill()
        }

        waitForExpectationsWithTimeout(TIMEOUT, handler: nil)
    }

    func testLibEmotlyMoods()  {
        let exp = expectationWithDescription("Expected list of moods")

        emoServ.updateMoods { err in
            XCTAssertGreaterThan(self.emoServ.moods.count, 5)
            exp.fulfill()
        }

        waitForExpectationsWithTimeout(TIMEOUT, handler: nil)
    }
}
