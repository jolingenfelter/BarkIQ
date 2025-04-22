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
/// is kept private to prevent accidental UI coupling.
///
/// The controller handles:
/// - Fetching breeds
/// - Generating randomized multiple-choice questions
/// - Tracking which answers were selected
/// - Returning a final results summary at the end
@Observable
final class QuizController {

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
            Logger.quizController.info("⚠️ Need to fetch breeds!")
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
        Logger.quizController.info("🧼 Reset quiz controller")
    }
    
    @MainActor
    func next() async {
        guard currentQuestionNumber <= settings.questionCount else {
            Logger.quizController.info("✅ Quiz complete with \(self.results.count) results")
            currentState = .results(results)
            return
        }

        currentState = .loading
        Logger.quizController.log("⏳ Loading question #\(self.currentQuestionNumber)...")

        do {
            try await fetchBreedsIfNeeded()
            let question = try await generateQuestion()

            currentState = .question(question)
            Logger.quizController.info("➡️ Loaded question #\(self.currentQuestionNumber):\n\(String(describing: question), privacy: .public)")

            currentQuestionNumber += 1
        } catch {
            Logger.quizController.error("❌ Error generating question: \(error.localizedDescription)")
            currentState = .error(error.localizedDescription)
        }
    }

    @discardableResult
    func checkAnswer(for question: Question, selected: Breed) -> QuestionResult {
        let result = QuestionResult(question: question, selectedAnswer: selected)
        results.append(result)
        Logger.quizController.info("📈 Appended to quiz results:\n\(result)")
        return result
    }

    private func generateQuestion() async throws -> Question {
        guard let answer = settings.breeds.randomElement() else {
            Logger.quizController.error("❌ Failed to get random breed for question")
            throw Error.failedToGenerateQuestion("Random element failure.")
        }

        let imageUrl = try await apiClient.fetchImageUrl(answer)
        let numberOfChoices = Int.random(in: 3...4)
        let otherBreeds = settings.breeds.filter { $0 != answer }.shuffled()

        guard otherBreeds.count >= numberOfChoices - 1 else {
            Logger.quizController.error("❌ Failed to generate question: not enough distractors")
            throw Error.failedToGenerateQuestion("Not enough distractors.")
        }

        let distractors = Array(otherBreeds.prefix(numberOfChoices - 1))
        let choices = distractors.shuffled()

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
