//
//  Question.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import Foundation

struct Question: Hashable, Equatable {
    let id: UUID = UUID()
    let imageData: Data
    let questionText: String
    let choices: [Breed]
    let answer: Breed
    
    static func mock() -> Question {
        let answer = Breed(name: "terrier", subType: "wheaten")
        
        let breeds = [
            answer,
            Breed(name: "dalmatian"),
            Breed(name: "poodle"),
            Breed(name: "bulldog")
        ]
        
        guard let url = Bundle.main.url(forResource: "jacopo", withExtension: "jpg"),
              let imageData = try? Data(contentsOf: url) else {
            fatalError("Missing or invalid test image")
        }
        
        return Question(
            imageData: imageData,
            questionText: "What breed is this dog?",
            choices: breeds.shuffled(),
            answer: answer
        )
    }
}
