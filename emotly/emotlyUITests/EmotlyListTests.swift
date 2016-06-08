//
//  EmotlyList.swift
//  emotly
//
//  Created by Tiziana Sellitto on 01/06/16.
//  Copyright © 2016 com.sempliva. All rights reserved.
//

import XCTest

class EmotlyList: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchEnvironment = ["UI_TESTING_MODE": "true"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmotlyList() {
        XCTAssertEqual(app.tables.count, 1)
        let table = app.tables.elementBoundByIndex(0)
        XCTAssertEqual(table.cells.count, 2, "found instead: \(table.cells.debugDescription)")
        
        table.cells.staticTexts["buh"].tap()
        table.cells.elementBoundByIndex(0).staticTexts["feels"].tap()
        table.cells.staticTexts["testgetown"].tap()
    }
    
}
