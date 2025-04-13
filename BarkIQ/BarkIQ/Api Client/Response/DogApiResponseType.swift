//
//  DogApiResponseType.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

enum DogApiResponseType<T: Codable>: Codable {
    case success(DogApiResponse<T>)
    case error(DogApiResponse<String>)
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DogApiResponse<T>.CodingKeys.self)
        let status = try container.decode(ResponseStatus.self, forKey: .status)
        
        switch status {
        case .success:
            self = .success(try DogApiResponse<T>(from: decoder))
        case .error:
            self = .error(try DogApiResponse<String>(from: decoder))
        }
    }
}
