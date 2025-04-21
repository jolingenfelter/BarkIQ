//
//  QuizSetupViewTests.swift
//  BarkIQUITests
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import XCTest

final class QuizSetupViewTests: XCTestCase {
    func createApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-use-mock-api", "-ui-tests"]
        return app
    }
    
    @MainActor
      func testQuizSetupScreenAppearsAndCanSelectQuestionCount() async throws {
          let app = createApp()
          app.launch()

          let quizMeButton = app.buttons["quiz-me-button"]
          XCTAssertTrue(quizMeButton.waitForExistence(timeout: 2))
          quizMeButton.tap()

          let setupScreen = app.staticTexts["Quiz Settings"]
          XCTAssertTrue(setupScreen.waitForExistence(timeout: 2))


          let picker = app.buttons["question-count-picker"]
          XCTAssertTrue(picker.exists, "There should be a picker")


          let startQuizButton = app.buttons["Start Quiz!"]
          XCTAssertTrue(startQuizButton.exists, "There should be a start quiz button")
      }
}
