//
//  QuizController.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import OSLog
import SwiftUI

/// A stateful controller that manages quiz progression, question generation, and result tracking.
///
/// This class is marked as `@Observable` to allow SwiftUI to respond to state changes like
/// transitioning from a question to results or showing a loading state. However, it aims to remain
/// as lightweight and intentional as possible, without leaning heavily on the observable pattern
/// for everything.
///
/// Only `currentState` is publicly reactive — most internal state (like question number and results)
/// is kept private to prevent accidental UI coupling. This keeps the update surface small and helps
/// avoid the pitfalls of `ObservableObject`, like redundant updates or unintended view re-renders.
///
/// The controller handles:
/// - Fetching and caching breeds (if needed)
/// - Generating randomized multiple-choice questions
/// - Tracking which answers were selected
/// - Returning a final results summary at the end
///
/// It’s designed to produce and advance quiz state, not hold onto long-term identity or deep view model logic.
@Observable
final class QuizController {
    enum Error: Swift.Error {
        case failedToGenerateQuestion
        case failedToFetchBreeds
    }
    
    enum QuizState: Equatable {
        case question(Question)
        case error(String)
        case results([QuestionResult])
        case loading
        case initial
    }

    private(set) var currentQuestionNumber: Int = 1
    
    private(set) var currentState: QuizState = .initial
    
    private var results: [QuestionResult] = []
    
    var settings = QuizSettings()
    let apiClient: DogApiClient

    init(apiClient: DogApiClient) {
        self.apiClient = apiClient
    }
    
    private func fetchBreedsIfNeeded() async throws {
        if settings.breeds.isEmpty {
            let breeds = try await apiClient.fetchBreeds()
            
            guard !breeds.isEmpty else {
                throw Error.failedToFetchBreeds
            }
            
            settings.breeds = breeds
        }
    }
    
    func reset() {
        self.currentQuestionNumber = 1
        self.results.removeAll()
        self.currentState = .initial
        Logger.quizController.info("Reset quiz controller")
    }
    
    func next() async {
       guard currentQuestionNumber <= settings.questionCount else {
           Logger.quizController.info("Quiz complete with \(self.results.count) results")
           self.currentState = .results(results)
           return
        }
        
        self.currentState = .loading
        
        do {
            try await fetchBreedsIfNeeded()
            
            let question = try await generateQuestion()
            
            self.currentState = .question(question)
            Logger.quizController.info("Update state to .question: \(String(describing: question), privacy: .public)")
            
            // Only increment the question number after a succesful
            // fetch has been made
            currentQuestionNumber += 1
        } catch {
            Logger.quizController.error("Error generating question: \(error.localizedDescription)")
            self.currentState = .error(error.localizedDescription)
        }
    }
    
    @discardableResult
    func checkAnswer(for question: Question, selected: Breed) -> QuestionResult {
        let result = QuestionResult(question: question, selectedAnswer: selected)
        results.append(result)
        Logger.quizController.info("Appended \(result) to results")
        return result
    }
    
    private func generateQuestion() async throws -> Question {
        guard let answer = settings.breeds.randomElement() else {
            throw Error.failedToGenerateQuestion
        }

        let imageUrl = try await apiClient.fetchImageUrl(answer)

        let numberOfChoices = Int.random(in: 3...4)

        // Get distractors that aren't the answer
        let otherBreeds = settings.breeds.filter { $0 != answer }.shuffled()

        guard otherBreeds.count >= numberOfChoices - 1 else {
            throw Error.failedToGenerateQuestion
        }

        let distractors = Array(otherBreeds.prefix(numberOfChoices - 1))

        let choices = (distractors).shuffled()
        
        let location = QuizLocation(
            questionNumber: currentQuestionNumber,
            totalCount: settings.questionCount
        )

        return Question(
            location: location,
            imageUrl: imageUrl,
            choices: choices,
            answer: answer
        )
    }
}
