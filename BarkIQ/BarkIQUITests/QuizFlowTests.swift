//
//  QuizFlowTests.swift
//  BarkIQUITests
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import XCTest

final class QuizFlowTests: XCTestCase {
    func createApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-use-mock-api", "-ui-tests"]
        return app
    }
    
    @MainActor
    func testDefaultLengthQuizFlow() async throws {
        let app = createApp()
        app.launch()

        // Navigate from main menu to setup screen
        let quizMeButton = app.buttons["quiz-me-button"]
        XCTAssertTrue(quizMeButton.exists, "Expected quiz me button to exist.")
        quizMeButton.tap()
        
        // Verify setup screen appears
        let setupScreen = app.staticTexts["Quiz Settings"]
        XCTAssertTrue(setupScreen.exists, "Expected Quiz Settings screen to exist.")
        
        // Tap "Start Quiz!" (uses default number of questions, which is 5)
        let startQuizButton = app.buttons["Start Quiz!"]
        XCTAssertTrue(startQuizButton.exists, "Expected start quiz button to exist.")
        startQuizButton.tap()
        
        // Iterate through the questions to reach the results screen
        for i in 1...5 {
            // Wait for first question to appear
            let questionText = app.staticTexts["What breed is this dog?"]
            XCTAssertTrue(questionText.waitForExistence(timeout: 2))
            
            let firstChoice = app.buttons["quiz-choice-button-0"]
            XCTAssertTrue(firstChoice.exists, "Expected choice button to exist.")
            firstChoice.tap()
            
            // SwiftUI still animates the transition of the next button in, even though
            // animations are disabled globally
            let nextbuttonIdentifier = i < 5 ? "next-question-button" : "see-results-button" //
            let nextQuestionButton = app.buttons[nextbuttonIdentifier]
            XCTAssertTrue(nextQuestionButton.waitForExistence(timeout: 2), "Expected next button to exist.")
            nextQuestionButton.tap()
        }

        let resultsScreen = app.staticTexts["Score"]
        XCTAssertTrue(resultsScreen.waitForExistence(timeout: 2), "Expected score screen to exist.")
        
        let closeButton = app.buttons["close-button"]
        XCTAssertTrue(closeButton.exists, "Expected score screen to exist.")
        closeButton.tap()
    }
}
