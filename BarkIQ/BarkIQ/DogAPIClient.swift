//
//  DogAPIClient.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Foundation

enum DogAPIClientError: Error {
    case invalidURL
}

struct DogAPIClient {
    func fetchBreeds() async throws -> [Breed] {
        guard let breedsURL = DogApiEndpoint.breeds.url else {
            throw DogAPIClientError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: breedsURL)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        print(json)
        
        return []
    }
}
