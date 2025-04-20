//
//  QuizActions.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

/// `QuizActions` is injected into the environment so views involved in the quiz
/// (like question screens or results) can trigger side effects without needing
/// direct access to the `QuizController`. 
struct QuizActions {
    var next: () async -> Void
    var recordAnswer: (_ question: Question, _ selected: Breed) -> QuestionResult?
    var quit: () -> Void
    var restart: () -> Void
}
