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

/*
 * A Mood.
 */
class Mood: NSObject {
    // MARK: Properties
    var id: NSNumber
    var value: NSString

    // MARK: Inizialization
    override init() {
        self.id = 0
        self.value = ""
    }
    init(id: NSNumber,value: NSString) {
        self.id = id
        self.value = value
    }
}

/*
 * An Emotly, pure and simple.
 */

class Emotly: NSObject {
    // MARK: Properties
    var mood: Mood
    var user: User
    var created_at: NSDate

    // MARK: Inizialization
    override init() {
        self.mood = Mood()
        self.user = User()
        self.created_at = NSDate()
    }
    init(mood: Mood, user: User, created_at: NSDate) {
        self.mood = mood
        self.user = user
        self.created_at = created_at
    }
}

/*
 * User.
 */

class User: NSObject {
    // MARK: Properties
    var nickname: NSString

    // MARK: Inizialization
    override init() {
        self.nickname = ""
    }
    init(nickname: NSString) {
        self.nickname = nickname
    }
}
