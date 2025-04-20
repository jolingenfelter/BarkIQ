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
    
    enum QuizStep {
        case question(Question?)
        case error(String)
        case results
    }

    private var currentQuestionNumber: Int = 0
    
    private let settings: QuizSettings
    private let apiClient: DogApiClient
    
    private(set) var currentStep: QuizStep = .question(nil)

    init(settings: QuizSettings,
         apiClient: DogApiClient
    ) {
        self.settings = settings
        self.apiClient = apiClient
    }
    
    var currentQuestion: Question? {
        guard case .question(let question) = currentStep else {
            return nil
        }
        
        return question
    }
    
    var progressDisplay: String {
        "\(currentQuestionNumber)/\(settings.questionCount)"
    }
    
    func next() async {
       guard currentQuestionNumber <= settings.questionCount else {
           self.currentStep = .results
           return
        }
        
        self.currentStep = .question(nil)
        currentQuestionNumber += 1
        
        do {
            let question = try await generateQuestion(number: currentQuestionNumber)
            self.currentStep = .question(question)
        } catch {
            self.currentStep = .error(error.localizedDescription)
        }
    }
    
    func checkAnswer(selected: Breed) -> Bool {
        guard case .question(let question) = currentStep else {
            return false
        }
        
        return question?.answer == selected
    }
    
    private func generateQuestion(number: Int) async throws -> Question {
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
            number: number,
            imageUrl: imageUrl,
            choices: choices,
            answer: answer
        )
    }
}
