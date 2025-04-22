//
//  QuizLocation.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

/// Represents the current position of a question within a quiz.
/// Used to show progress (e.g. "3/10").
struct QuizLocation: Equatable, Hashable {
    /// The current question number (1-based).
    let questionNumber: Int
    
    // The total number of questions in the quiz.
    let totalCount: Int
    
    var isAtStart: Bool {
        questionNumber == 1
    }
    
    var isAtEnd: Bool {
        questionNumber == totalCount
    }
    
    var displayText: String {
        "\(questionNumber)/\(totalCount)"
    }
}
