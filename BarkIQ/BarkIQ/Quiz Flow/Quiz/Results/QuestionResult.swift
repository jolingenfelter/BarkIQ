//
//  QuestionResult.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

struct QuestionResult: Equatable, Hashable, CustomStringConvertible {
    let question: Question
    let selectedAnswer: Breed
    
    var isCorrect: Bool {
        question.answer == selectedAnswer
    }
    
    var description: String {
        """
        QuestionResult {
            selectedAnswer: \(selectedAnswer),
            correctAnswer: \(question.answer),
            isCorrect: \(isCorrect)
        }
        """
    }
    
    static let mock1 = QuestionResult(question: .mock(), selectedAnswer: .mock1)
    static let mock2 = QuestionResult(question: .mock(), selectedAnswer: .mock2)
    static let mock3 = QuestionResult(question: .mock(), selectedAnswer: .mock2)
    
    static let mockArray = [mock1, mock2, mock3]
}
