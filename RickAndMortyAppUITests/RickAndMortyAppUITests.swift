//
//  RickAndMortyAppUITests.swift
//  RickAndMortyAppUITests
//
//  Created by Adrian Flores Herrera on 5/6/26.
//

import XCTest

final class RickAndMortyAppUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func test_fullCharacterFlow() {

        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))

        firstCell.tap()

        app.navigationBars.buttons.element(boundBy: 0).tap()

        XCTAssertTrue(app.cells.firstMatch.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
