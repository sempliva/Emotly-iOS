//
//  NewEmotlyTests.swift
//  emotly
//
//  Created by Tiziana Sellitto on 07/06/16.
//  Copyright © 2016 com.sempliva. All rights reserved.
//

import XCTest

class NewEmotlyTests: XCTestCase {
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
    

//    func testNewEmotly() {
//        let addButton = app.navigationBars["Emoties"].buttons["Add"]
//        addButton.tap()
//        app.navigationBars["New Emotly"].buttons["Cancel"].tap()
//        addButton.tap()
//        app.tables.staticTexts["sad"].tap()
//    }
    
}
