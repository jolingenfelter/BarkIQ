//
//  QuestionResult.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

struct QuestionResult: Equatable, Hashable {
    let question: Question
    let selectedAnswer: Breed
    
    var isCorrect: Bool {
        question.answer == selectedAnswer
    }
}
