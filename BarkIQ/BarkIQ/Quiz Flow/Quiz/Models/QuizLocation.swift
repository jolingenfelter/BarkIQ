//
//  QuizLocation.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

struct QuizLocation: Equatable, Hashable {
    let questionNumber: Int
    let totalCount: Int
    
    var displayText: String {
        "\(questionNumber)/\(totalCount)"
    }
}
