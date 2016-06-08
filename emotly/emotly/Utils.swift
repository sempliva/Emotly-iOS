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

// Extension to NSDate class. Used to create relative date.
extension NSDate {
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: NSCalendarOptions()).year
    }
    
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: NSCalendarOptions()).month
    }
    
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: NSCalendarOptions()).weekOfYear
    }
    
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: NSCalendarOptions()).day
    }
    
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: NSCalendarOptions()).hour
    }
    
    func minutesFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: NSCalendarOptions()).minute
    }
    
    func secondsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: NSCalendarOptions()).second
    }
    
    var relativeTime: String {
        let now = NSDate()
        if (now.yearsFrom(self) > 0) {
            return now.yearsFrom(self).description  + " year" + { return now.yearsFrom(self) > 1 ? "s" : "" }() + " ago"
        }
        if (now.monthsFrom(self) > 0) {
            return now.monthsFrom(self).description + " month" + { return now.monthsFrom(self) > 1 ? "s" : "" }() + " ago"
        }
        if (now.weeksFrom(self) > 0) {
            return now.weeksFrom(self).description + " week" + { return now.weeksFrom(self) > 1 ? "s" : "" }() + "ago"
        }
        if (now.daysFrom(self) > 0) {
            if now.daysFrom(self) == 1 { return "Yesterday" }
            return now.daysFrom(self).description + " days ago"
        }
        if (now.hoursFrom(self) > 0) {
            return "\(now.hoursFrom(self)) hour" + { return now.hoursFrom(self) > 1 ? "s" : "" }() + " ago"
        }
        if (now.minutesFrom(self) > 0) {
            return "\(now.minutesFrom(self)) minute" + { return now.minutesFrom(self) > 1 ? "s" : "" }() + " ago"
        }
        if (now.secondsFrom(self) > 0) {
            if now.secondsFrom(self) < 15 { return "Just now" }
            return "\(now.secondsFrom(self)) second" + { return now.secondsFrom(self) > 1 ? "s" : "" }() + " ago"
        }
        return ""
    }
}
