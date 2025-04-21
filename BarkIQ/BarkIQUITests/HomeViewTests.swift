//
//  BarkIQUITests.swift
//  BarkIQUITests
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import XCTest

final class HomeViewTests: XCTestCase {
    
    func createApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-use-mock-api"]
        app.launchArguments.append("-ui-tests")
        return app
    }

    @MainActor
    func testHomeViewContainsQuizAndStatsButtons() throws {
        let app = createApp()
        app.launch()
        
        let quizMeButton = app.buttons["quiz-me-button"]
        XCTAssertTrue(quizMeButton.exists, "Quiz me button should exist.")
        
        let statsButton = app.buttons["stats-button"]
        XCTAssertTrue(statsButton.exists, "Stats button should exist")
    }
    
    @MainActor
    func testHomeTapQuizMePresentsQuizSettings() throws {
        let app = createApp()
        app.launch()
        
        let quizMeButton = app.buttons["quiz-me-button"]
        XCTAssertTrue(quizMeButton.exists)
        
        quizMeButton.tap()
        let setupTitle = app.staticTexts["Quiz Settings"]
        XCTAssertTrue(setupTitle.exists, "Setup screen title should appear.")
    }
    
    @MainActor
    func testHomeTapStatsPushesBreedStats() throws {
        let app = createApp()
        app.launch()
        
        let statsButton = app.buttons["stats-button"]
        XCTAssertTrue(statsButton.exists)
        
        statsButton.tap()
        let statsTitle = app.staticTexts["Stats by breed"]
        XCTAssertTrue(statsTitle.exists, "Setup screen title should appear.")
    }
}
