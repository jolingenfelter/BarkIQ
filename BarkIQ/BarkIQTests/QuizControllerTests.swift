//
//  QuizControllerTests.swift
//  BarkIQTests
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Testing
import Foundation

@testable import BarkIQ

struct QuizControllerTests {
    
    @Test func testNextProducesValidQuestion() async throws {
        let controller = QuizController(apiClient: .mock)
        controller.settings = QuizSettings(questionCount: 1)
        await controller.next()
        
        switch controller.currentState {
        case .question(let question):
            // Questions should have 3 or 4 choices
            #expect(question.choices.count >= 3 && question.choices.count <= 4, "Expected question to have 3 or 4 choices, but got \(question.choices.count)")
            // The choices should contain answer
            #expect(question.choices.contains(question.answer), "The question's choices should contain the answer.")
            
            // Ensure that all choices are unique
            let expected = Set(question.choices).count
            let actual = question.choices.count
            #expect(expected == actual, "Expected \(expected) choices, but got \(actual).")
        default:
            Issue.record("Expected .question state, but got \(controller.currentState)")
        }
    }
    
    @Test func testErrorStateWhenImageFetchFails() async {
        let failingImageFetch = DogApiClient(
            fetchBreeds: {
                Breed.mockArray
            },
            fetchImageUrl: { _ in
                throw DogApiClient.Error.responseError("Mocked image fetch failure")
            }
        )
        
        let controller = QuizController(apiClient: failingImageFetch)
        
        controller.settings = QuizSettings(
            questionCount: 1,
            breeds: Breed.mockArray
        )
        
        await controller.next()
        
        guard case .error = controller.currentState else {
            Issue.record("Expected .error state, got \(controller.currentState)")
            return
        }
        
        let currentQuestionNumber = controller.currentQuestionNumber
        #expect(currentQuestionNumber == 1, "Expected current question number to be 1 but got \(currentQuestionNumber)")
    }
    
    @Test func testErrorStateWhenBreedsArrayIsEmpty() async {
        let failingImageFetch = DogApiClient(
            fetchBreeds: {
                []
            },
            fetchImageUrl: { _ in
                // Irrelevant here
                throw DogApiClient.Error.responseError("Mocked image fetch failure")
            }
        )
        
        let controller = QuizController(apiClient: failingImageFetch)
        
        controller.settings = QuizSettings(
            questionCount: 1,
            breeds: Breed.mockArray
        )
        
        await controller.next()
        
        guard case .error = controller.currentState else {
            Issue.record("Expected .error state, got \(controller.currentState)")
            return
        }
        
        let currentQuestionNumber = controller.currentQuestionNumber
        #expect(currentQuestionNumber == 1, "Expected current question number to be 1 but got \(currentQuestionNumber)")
    }
    
    @Test func testResultsStateHasExpectedResults() async throws {
        let controller = QuizController(apiClient: .mock)
        controller.settings = QuizSettings(questionCount: 2)
        
        for _ in 0..<controller.settings.questionCount {
            await controller.next()
            
            guard case .question(let question) = controller.currentState else {
                Issue.record("Expected .question state")
                return
            }
            
            // Check the answer every time so that it gets appended to the
            // results array
            _ = controller.checkAnswer(for: question, selected: question.answer)
        }
        
        await controller.next()
        
        // Assert that state is now .results and results are correct
        guard case .results(let results) = controller.currentState else {
            Issue.record("Expected .results state, got \(controller.currentState)")
            return
        }
        
        #expect(results.count == 2, "Expected 2 results but got \(results.count) instead.")
        #expect(results.allSatisfy { $0.isCorrect },"Expected all correct answers but found some incorrect.")
    }
    
    @Test func testResetAfterQuizCompletes() async {
        let controller = QuizController(apiClient: .mock)
        controller.settings = QuizSettings(
            questionCount: 3,
            breeds: Breed.mockArray
        )
        
        // Complete the quiz
        for _ in 0..<controller.settings.questionCount {
            await controller.next()
            
            guard case .question(let question) = controller.currentState else {
                Issue.record("Expected .question state")
                return
            }
            
            _ = controller.checkAnswer(for: question, selected: question.answer)
        }
        
        await controller.next()
        
        // Assert we're in the results state
        guard case .results(let results) = controller.currentState else {
            Issue.record("Expected .results state before reset")
            return
        }
        
        #expect(results.count == controller.settings.questionCount)
        
        // Now reset
        controller.reset()
        
        // Confirm state was cleared
        #expect(controller.currentState == .initial, "Reset should return state to .initial")
        
        await controller.next()
        
        guard case .question(let question) = controller.currentState else {
            Issue.record("Expected .question state after reset")
            return
        }
        
        #expect(question.location.questionNumber == 1, "Reset should restart quiz from question 1")
    }
    
    @Test func testIncorrectAnswerIsHandled() async {
        let controller = QuizController(apiClient: .mock)
        controller.settings = QuizSettings(questionCount: 1, breeds: Breed.mockArray)
        
        await controller.next()
        
        guard case .question(let question) = controller.currentState else {
            Issue.record("Expected .question state")
            return
        }
        
        let incorrect = question.choices.first { $0 != question.answer }!
        let result = controller.checkAnswer(for: question, selected: incorrect)
        
        #expect(result.isCorrect == false, "Expected result to be incorrect.")
    }
}
