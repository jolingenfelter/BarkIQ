//
//  DogApiClient.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Foundation
import OSLog

/// Used to fetch dog breed data and images from the Dog CEO API.
/// Constructed so that it can be inserted into the environment and easily replaced
/// with a mock for testing or previews. All operations are asynchronous and throw
/// on failure.
struct DogApiClient {
    var fetchBreeds: () async throws -> [Breed]
    var fetchImageUrl: (_ for: Breed) async throws -> URL
    
    static let live: DogApiClient = DogApiClient(
        fetchBreeds: DogApiLive.fetchBreeds,
        fetchImageUrl: DogApiLive.fetchImageUrl,
    )
    
    static let mock: DogApiClient = DogApiClient(
        fetchBreeds: {
            Breed.mockArray
        },
        fetchImageUrl: { breed in
            guard let url = Bundle.main.url(forResource: "jacopo", withExtension: "jpg") else {
                throw Error.invalidURL
            }
            
            return url
        }
    )
}

private enum DogApiLive {
    
    static func fetchImageUrl(for breed: Breed) async throws -> URL {
        guard let imageURL = DogApiEndpoint.randomImage(breed).url else {
            Logger.networking.error("❌ Failed to create url fetching image for \(breed.displayName)")
            throw DogApiClient.Error.invalidURL
        }
        
        return try await fetchData(from: imageURL)
    }
    
    static func fetchBreeds() async throws -> [Breed] {
        guard let breedsURL = DogApiEndpoint.breeds.url else {
            Logger.networking.error("❌ Failed to create url fetching breeds list")
            throw DogApiClient.Error.invalidURL
        }
        
        let breedsData: [String: [String]] = try await fetchData(from: breedsURL)
        let breeds = BreedsResponseParser.parseBreeds(breedsData)
        
        #if DEBUG
        Logger.networking.debug("🐾 Parsed breeds:\n\(breeds.map(\.displayName).joined(separator: "\n"))")
        #endif
        
        return breeds
    }
    
    private static func parseApiResponse<T: Codable>(_ data: Data, from url: URL) throws -> T {
        Logger.networking.info("📥 Attempting to parse API response of type \(T.self) from url: \(url.absoluteString)")
        
        do {
            let response = try JSONDecoder().decode(DogApiResponseType<T>.self, from: data)
            
            switch response {
            case .success(let success):
                Logger.networking.info("✅ Successfully parsed response with type \(T.self) from url: \(url.absoluteString)")
                return success.message
            case .error(let failure):
                Logger.networking.error("❌ Parsed error response from url: \(url.absoluteString):\n\(failure.description)")
                throw DogApiClient.Error.responseError("The request failed: \(failure.message)")
            }
        } catch {
            Logger.networking.error("❌ Failed trying to parse \(T.self)")
            throw DogApiClient.Error.parsingError(error.localizedDescription)
        }
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
            Logger.networking.info("📦 Received response from url: \(url.absoluteString)")
            
            return try parseApiResponse(data, from: url)
        } catch let error as DogApiClient.Error {
            throw error // Already DogApiClient.Error so just throw it
        } catch {
            // An uknown error type that likely comes from the server
            Logger.networking.error("❌ Exception while fetching from url: \(url) with error: \(error.localizedDescription)")
            throw DogApiClient.Error.unknown(error)
        }
    }
}
