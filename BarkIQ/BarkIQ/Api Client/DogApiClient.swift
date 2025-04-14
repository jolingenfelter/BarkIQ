//
//  DogApiClient.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Foundation
import OSLog

struct DogApiClient {
    
    enum DogApiClientError: Error {
        case invalidURL
        case responseError(String)
    }
    
    static func fetchImageData(for breed: Breed) async throws -> Data {
        guard let imageURL = DogApiEndpoint.randomImage(breed).url else {
            Logger.networking.error("❌ Failed to create url fetching image for \(breed.displayName)")
            throw DogApiClientError.invalidURL
        }
        
        let resultUrl: URL = try await fetchData(from: imageURL)
        Logger.networking.info("🐾 Image result url: \(resultUrl)")
        
        var request = URLRequest(url: resultUrl)
        request.timeoutInterval = 10.0

        // The API returns a JSON-wrapped image URL. Fetch the
        // image data separately in another session.
        Logger.networking.info("🐾 Starting request to url: \(resultUrl)")
        let session = URLSession(configuration: .ephemeral)
        let (data, _) = try await session.data(for: request)
        Logger.networking.info("📦 Received image data from url: \(resultUrl)")
        
        return data
    }
    
    static func fetchBreeds() async throws -> [Breed] {
        guard let breedsURL = DogApiEndpoint.breeds.url else {
            Logger.networking.error("❌ Failed to create url fetching breeds list")
            throw DogApiClientError.invalidURL
        }
        
        let breedsData: [String: [String]] = try await fetchData(from: breedsURL)
        let breeds = BreedsResponseParser.parseBreeds(breedsData)
        
        #if DEBUG
        Logger.networking.debug("🐾 Parsed breeds:\n\(breeds.map(\.description).joined(separator: "\n"))")
        #endif
        
        return breeds
    }
    
    private static func fetchData<T: Codable>(from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0

        // This API was frequently throwing errors related to QUIC.
        // Using an ephemeral session fixes this.
        let session = URLSession(configuration: .ephemeral)
        
        do {
            Logger.networking.info("🐾 Starting request to url: \(url.absoluteString)")
            
            let (data, _) = try await session.data(for: request)
            let response = try JSONDecoder().decode(DogApiResponseType<T>.self, from: data)
       
            Logger.networking.info("📦 Received response from url: \(url.absoluteString)")
            
            switch response {
            case .success(let success):
                Logger.networking.info("✅ Successful fetch from url: \(url.absoluteString)")
                return success.message
            case .error(let failure):
                // The API has returned a response, but it had an `error` status
                // or parsing failed
                Logger.networking.error("❌ Received an error response from url: \(url):\n\(failure.description)")
                throw DogApiClientError.responseError("The request failed: \(failure.message)")
            }
        } catch {
            Logger.networking.error("❌ Exception while fetching from url: \(url) with error: \(error.localizedDescription)")
            throw error
        }
    }
}
