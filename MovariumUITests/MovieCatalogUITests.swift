//
//  MovariumUITests.swift
//  MovariumUITests
//
//  Created by Anton Solovev on 05.05.2026.
//

import XCTest

final class MovariumUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))
    }
}
