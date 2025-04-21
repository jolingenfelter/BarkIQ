//
//  QuizController+Error.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import Foundation

extension QuizController {
    enum Error: LocalizedError {
        case failedToGenerateQuestion(_ reason: String)
        case failedToFetchBreeds
        
        var errorDescription: String? {
            switch self {
            case .failedToGenerateQuestion(let reason):
                "Failed to generate question: \(reason)"
            case .failedToFetchBreeds:
                "Error: Failed to fetch breeds."
            }
        }
    }
}
