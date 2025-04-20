//
//  Question.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import Foundation

/// A model representing a QuizQuestion.  Note that
/// when creating a quiz question, value provided to answer
/// is automatically added to the choices array.
struct Question: Hashable, Equatable {
    let location: QuizLocation
    let imageUrl: URL?
    let questionText: String = "What breed is this dog?"
    let choices: [Breed]
    let answer: Breed
    
    init(
        location: QuizLocation,
        imageUrl: URL?,
        choices: [Breed],
        answer: Breed
    ) {
        self.location = location
        self.imageUrl = imageUrl
        
        let allChoices  = choices + [answer]
        self.choices = allChoices.shuffled()
        
        self.answer = answer
    }
    
    static func mock() -> Question {
        let answer: Breed = .mock1
        
        let distractions: [Breed] = [.mock2, .mock3, .mock4]
        
        guard let url = Bundle.main.url(forResource: "jacopo", withExtension: "jpg") else {
            fatalError("Missing or invalid test image")
        }
        
        return Question(
            location: QuizLocation(
                questionNumber: 1,
                totalCount: 5
            ),
            imageUrl: url,
            choices: distractions.shuffled(),
            answer: answer
        )
    }
}
