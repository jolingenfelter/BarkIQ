//
//  Question.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import Foundation

struct Question: Hashable, Equatable {
    let id: UUID = UUID()
    let imageUrl: URL
    let questionText: String
    let choices: [Breed]
    let answer: Breed
    
    static func mock() -> Question {
        let answer: Breed = .mock1
        
        let breeds: [Breed] = [answer, .mock2, .mock3, .mock4]
        
        guard let url = Bundle.main.url(forResource: "jacopo", withExtension: "jpg") else {
            fatalError("Missing or invalid test image")
        }
        
        return Question(
            imageUrl: url,
            questionText: "What breed is this dog?",
            choices: breeds.shuffled(),
            answer: answer
        )
    }
}
