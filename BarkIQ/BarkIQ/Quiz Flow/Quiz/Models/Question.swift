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
struct Question: Hashable, Equatable, CustomStringConvertible {
    /// A unique id assigned to the question
    let uuid = UUID()
    
    /// The location of the question in the quiz
    let location: QuizLocation
    
    /// The url that contains the image to be displayed
    let imageUrl: URL
    
    /// The text displayed to the user below the image
    let questionText: String = "What breed is this dog?"
    
    /// The breeds displayed to the user in the choice
    /// buttons.  This array includes the answer.
    let choices: [Breed]
    
    /// The correct answer (i.e. the name of the breed
    /// that matches the image)
    let answer: Breed
    
    init(
        location: QuizLocation,
        imageUrl: URL,
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
        let answer: Breed = Breed.mockArray.first ?? .mock1
        
        let distractionPool = Breed.mockArray.filter { $0 != answer }
        let distractions = Array(distractionPool.shuffled().prefix(3))
        
        guard let url = Bundle.main.url(forResource: "jacopo", withExtension: "jpg") else {
            fatalError("Missing or invalid test image")
        }
        
        return Question(
            location: QuizLocation(
                questionNumber: 1,
                totalCount: 5
            ),
            imageUrl: url,
            choices: distractions,
            answer: answer
        )
    }
    
    var description: String {
        """
        Question {
            location: \(location.displayText),
            imageUrl: \(imageUrl.absoluteString),
            questionText: \(questionText),
            choices: \(choices.map(\.displayName).joined(separator: ", "))
            answer: \(answer.displayName)
        }
        """
    }
}
