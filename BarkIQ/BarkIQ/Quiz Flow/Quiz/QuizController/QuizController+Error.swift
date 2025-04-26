//
//  QuizController+Error.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import Foundation

extension QuizController {
    /// An Error type for errors that occur in the
    /// management and manipulation of data
    /// in the `QuizController`
    enum Error: LocalizedError {
        /// Thrown when question generation fails
        /// due to breeds not being available or failure
        /// required data returning nil.  In general, this
        /// error is caused by errors handling data.
        case failedToGenerateQuestion(_ reason: String)
        
        /// Thrown when the breeds array is empty
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
