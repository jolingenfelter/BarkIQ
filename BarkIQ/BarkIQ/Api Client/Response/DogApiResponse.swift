//
//  DogApiResponse.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

struct DogApiResponse<T: Codable>: Codable, CustomStringConvertible {
    let status: ResponseStatus
    let message: T
    let code: Int?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case code = "code"
    }
    
    var description: String {
        """
        DogApiResponse {
            status: \(status.rawValue),
            message: \(message),
            code: \(String(describing: code))
        }
        """
    }
}
