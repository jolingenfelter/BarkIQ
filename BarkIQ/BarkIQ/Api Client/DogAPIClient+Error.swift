//
//  DogAPIClient+Error.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import Foundation

extension DogApiClient {
    enum Error: LocalizedError {
        /// Indicates the URL could not be constructed (usually due to a malformed breed).
        case invalidURL
        
        /// Indicates a successful HTTP request returned an error from the API (e.g., bad breed name).
        case responseError(String)
        
        /// Indicates that a success response was received but parsing failed
        case parsingError(String)
        
        /// A catch-all for any other unexpected failure.
        case unknown(Swift.Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .responseError(let message):
                return "API Error: \(message)"
            case .parsingError(let message):
                return "Parsing Error: \(message)"
            case .unknown(let error):
                return error.localizedDescription
            }
        }
    }
}
