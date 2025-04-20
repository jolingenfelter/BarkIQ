//
//  QuizLocation.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

struct QuizLocation: Equatable, Hashable {
    let questionNumber: Int
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
