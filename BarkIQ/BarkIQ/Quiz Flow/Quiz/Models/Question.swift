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
    let title: String
    let imageUrl: URL?
    let questionText: String = "What breed is this dog?"
    let choices: [Breed]
    let answer: Breed
    
    init(
        title: String,
        imageUrl: URL?,
        choices: [Breed],
        answer: Breed
    ) {
        self.title = title
        self.imageUrl = imageUrl
        
        let allChoices  = choices + [answer]
        self.choices = allChoices.shuffled()
        
        self.answer = answer
    }
    
    static func mock() -> Question {
        let answer: Breed = .mock1
        
        let breeds: [Breed] = [answer, .mock2, .mock3, .mock4]
        
        guard let url = Bundle.main.url(forResource: "jacopo", withExtension: "jpg") else {
            fatalError("Missing or invalid test image")
        }
        
        return Question(
            title: "1/5",
            imageUrl: url,
            choices: breeds.shuffled(),
            answer: answer
        )
    }
}
