//
//  QuizActions.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

// TODO: Add documentation
struct QuizActions {
    var next: () async -> Void
    var recordAnswer: (_ question: Question, _ selected: Breed) -> QuestionResult?
    var quit: () -> Void
}
