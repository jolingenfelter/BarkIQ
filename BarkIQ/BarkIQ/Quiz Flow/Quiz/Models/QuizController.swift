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
    
    var currentQuestion: Question? {
        guard case .question(let question) = currentState else {
            return nil
        }
        
        return question
    }
    
    var progressDisplay: String {
        guard case .question = currentState else {
            return ""
        }
        
        return "\(currentQuestionNumber)/\(settings.questionCount)"
    }
    
    func startQuiz() async {
        do {
            let breeds = try await apiClient.fetchBreeds()
            self.settings.breeds = breeds
            
            await next()
        } catch {
            self.currentState = .error(error.localizedDescription)
        }
    }
    
    func next() async {
       guard currentQuestionNumber < settings.questionCount else {
           self.currentState = .results
           return
        }
        
        self.currentState = .loading
        
        do {
            let question = try await generateQuestion()
            currentQuestionNumber += 1
            
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
    
    private func generateQuestion() async throws -> Question {
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
            imageUrl: imageUrl,
            choices: choices,
            answer: answer
        )
    }
}
