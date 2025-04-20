//
//  QuizController.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

@Observable
final class QuizController {
    enum QuizError: Error {
        case failedToGenerateQuestion
    }
    
    enum QuizState: Equatable {
        case question(Question)
        case error(String)
        case results
        case loading
    }

    private var currentQuestionNumber: Int = 0
    
    var settings = QuizSettings()
    private let apiClient: DogApiClient
    
    private(set) var currentState: QuizState = .loading

    init(apiClient: DogApiClient) {
        self.apiClient = apiClient
    }
    
    private func fetchBreedsIfNeeded() async throws {
        if settings.breeds.isEmpty {
            settings.breeds = try await apiClient.fetchBreeds()
        }
    }
    
    func next() async {
       guard currentQuestionNumber < settings.questionCount else {
           self.currentState = .results
           self.currentQuestionNumber = 0
           return
        }
        
        self.currentState = .loading
        
        do {
            try await fetchBreedsIfNeeded()
            
            currentQuestionNumber += 1
            let question = try await generateQuestion(title: "\(currentQuestionNumber)/\(settings.questionCount)")
            
            self.currentState = .question(question)
        } catch {
            self.currentState = .error(error.localizedDescription)
        }
    }
    
    func checkAnswer(selected: Breed) -> Bool {
        guard case .question(let question) = currentState else {
            return false
        }
        
        return question.answer == selected
    }
    
    private func generateQuestion(title: String) async throws -> Question {
        guard let answer = settings.breeds.randomElement() else {
            throw QuizError.failedToGenerateQuestion
        }

        let imageUrl = try await apiClient.fetchImageUrl(answer)

        let numberOfChoices = Int.random(in: 3...4)

        // Get distractors that aren't the answer
        let otherBreeds = settings.breeds.filter { $0 != answer }.shuffled()

        guard otherBreeds.count >= numberOfChoices - 1 else {
            throw QuizError.failedToGenerateQuestion
        }

        let distractors = Array(otherBreeds.prefix(numberOfChoices - 1))

        let choices = (distractors).shuffled()

        return Question(
            title: title,
            imageUrl: imageUrl,
            choices: choices,
            answer: answer
        )
    }
}
