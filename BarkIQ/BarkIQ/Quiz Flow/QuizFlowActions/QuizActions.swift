//
//  quizFlowActions.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

/// `QuizFlowActions` is injected into the environment so views involved in the quiz
/// (like question screens or results) can trigger side effects without needing
/// direct access to the `QuizController`. 
struct QuizFlowActions {
    ///  Call to move onto the next question. This is
    ///  Also used to start the quiz.
    var next: (() async -> Void)?
    
    /// Call to record an answer to the quiz controller
    /// and progress to the `showAnswer` state when
    /// the user answers a question.
    var recordAnswer: ((_ question: Question, _ selected: Breed) -> QuestionResult)?
    
    /// Call to close the quiz
    var quit: (() -> Void)?
    
    /// Call to restart the quiz, resetting the quiz controller.
    var restart: (() -> Void)?
    
    static let mock = QuizFlowActions(
        next: {
            try? await Task.sleep(for: .seconds(2))
        },
        recordAnswer: { question, selection in
            QuestionResult(
                question: question,
                selectedAnswer: selection
            )
        }
    )
}
