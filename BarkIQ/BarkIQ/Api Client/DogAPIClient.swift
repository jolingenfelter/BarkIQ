//
//  DogAPIClient.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Foundation
import OSLog

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
        let breeds = BreedsResponseParser.parseBreeds(breedsData)
        
        Logger.networking.debug("🐾 Parsed breeds: \(breeds.map(\.description).joined(separator: "\n"))")
        
        return breeds
    }
    
    private func fetchData<T: Codable>(from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5.0
        
        do {
            Logger.networking.info("🐾 Starting request to url: \(url.absoluteString)")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(DogApiResponseType<T>.self, from: data)
            
            Logger.networking.info("📦 Received response from url: \(url.absoluteString)")
            
            switch response {
            case .success(let success):
                Logger.networking.info("✅ Successful fetch from url: \(url.absoluteString)")
                return success.message
            case .error(let failure):
                // This happens when the API returns an error or parsing fails
                Logger.networking.error("❌ Exception while fetching from url: \(url) with error: \(failure.message)")
                throw DogAPIClientError.responseError("The request failed: \(failure.message)")
            }
        } catch {
            Logger.networking.error("❌ Exception while fetching from url: \(url) with error: \(error.localizedDescription)")
            throw error
        }
    }
}
