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

class modelTests: XCTestCase {
  
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Tests to confirm that the Mood initializer returns when no id or a value is provided.
    func testMoodInitialization() {
        // Success case.
        let potentialMood = Mood()
        XCTAssertNotNil(potentialMood)
        XCTAssertEqual(potentialMood.id, 0)
        XCTAssertEqual(potentialMood.value, "")
        
        let potentialMood2 = Mood(id: 1, value: "sad")
        XCTAssertNotNil(potentialMood2)
        XCTAssertEqual(potentialMood2.id, 1)
        XCTAssertEqual(potentialMood2.value, "sad")
    }
    
    // Tests to confirm that the Mood initializer returns when no id or a value is provided.
    func testUserInitialization() {
        // Success case.
        let potentialUser = User()
        XCTAssertNotNil(potentialUser)
        XCTAssertEqual(potentialUser.nickname, "")
        XCTAssertEqual(potentialUser.jwt, NSDictionary())
        
        let jwt: NSDictionary = [
            "header": ["algo": "sha256", "type": "jwt"],
            "payload": ["expire": "ghi", "nickname": "testnick"],
            "signature": "dbrGyPEVZaPKy"
        ]
        let potentialUser2 = User(nickname: "testnick", jwt: jwt)
        XCTAssertNotNil(potentialUser2)
        XCTAssertEqual(potentialUser2.nickname, "testnick")
        XCTAssertEqual(potentialUser2.jwt.allKeys.count, 3)
    }
    
    // Tests to confirm that the Mood initializer returns when no id or a value is provided.
    func testEmotlyInitialization() {
        // Success case.
        let potentialEmotly = Emotly()
        XCTAssertNotNil(potentialEmotly)
        XCTAssertEqual(potentialEmotly.mood.id, 0)
        XCTAssertEqual(potentialEmotly.user.nickname, "")
        XCTAssertEqual(potentialEmotly.user.jwt, NSDictionary())
        
        let jwt: NSDictionary = [
            "header": ["algo": "sha256", "type": "jwt"],
            "payload": ["expire": "ghi", "nickname": "testnick"],
            "signature": "dbrGyPEVZaPKy"
        ]
        let now = NSDate()
        let user = User(nickname: "testuser", jwt: jwt)
        let mood = Mood(id: 2, value: "happy")
        let potentialEmotly2 = Emotly(mood: mood, user: user, created_at: now)
        XCTAssertNotNil(potentialEmotly2)
        XCTAssertEqual(potentialEmotly2.mood.id, 2)
        XCTAssertEqual(potentialEmotly2.user.nickname, "testuser")
        XCTAssertEqual(potentialEmotly2.created_at, now)
        XCTAssertEqual(potentialEmotly2.user.jwt.allKeys.count, 3)
    }

    func testPerformanceExample() {
        self.measureBlock {
        }
    }
}
