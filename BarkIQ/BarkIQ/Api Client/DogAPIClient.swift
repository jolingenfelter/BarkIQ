//
//  DogAPIClient.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Foundation

struct DogAPIClient {
    
    enum DogAPIClientError: Error {
        case invalidURL
        case responseError(String)
    }
    
    func fetchBreeds() async throws -> [Breed] {
        guard let breedsURL = DogApiEndpoint.breeds.url else {
            throw DogAPIClientError.invalidURL
        }
        
        let breedsData: [String: [String]] = try await fetchData(from: breedsURL)
        return BreedsResponseParser.parseBreeds(breedsData)
    }
    
    private func fetchData<T: Codable>(from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5.0
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(DogApiResponseType<T>.self, from: data)
        
        let json = try JSONSerialization.jsonObject(with: data)
        print("json: \(json)")
        
        switch response {
        case .success(let success):
            return success.message
        case .error(let failure):
            throw DogAPIClientError.responseError("The request failed: \(failure.message)")
        }
    }
}
