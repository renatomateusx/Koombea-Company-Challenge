//
//  KoombeaChallengeTestUITests.swift
//  KoombeaChallengeTestUITests
//
//  Created by Renato Mateus De Moura Santos on 25/09/21.
//

import XCTest

class KoombeaChallengeTestUITests: XCTestCase {
    
    func testPullDownToRefresh() {
        let app = XCUIApplication()
        app.launch()
        _ = app.tables.firstMatch.waitForExistence(timeout: 5)
        let firstCell = app.tables.staticTexts.staticTexts.count
        app.tables.firstMatch.swipeDown()
        let secondCell = app.tables.staticTexts.staticTexts.count
        XCTAssertTrue(firstCell == secondCell)
    }
    
    func testLoadMore() {
        let app = XCUIApplication()
        app.launch()
        _ = app.tables.firstMatch.waitForExistence(timeout: 5)
        let firstCount = app.tables.staticTexts.count
        app.tables.firstMatch.swipeUp()
        var afterCount = app.tables.staticTexts.count
        afterCount += 5
        XCTAssertTrue(afterCount > firstCount)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
