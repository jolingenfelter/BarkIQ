//
//  DogApiClient.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import Foundation
import OSLog

struct DogApiClient {
    enum Error: Swift.Error {
        case invalidURL
        case responseError(String)
        case unknown(String)
    }
    
    var fetchBreeds: () async throws -> [Breed]
    var fetchImageUrl: (_ for: Breed) async throws -> URL
    var fetchImageData: (URL) async throws -> Data
    
    static let live: DogApiClient = DogApiClient(
        fetchBreeds: DogApiLive.fetchBreeds,
        fetchImageUrl: DogApiLive.fetchImageUrl(for:),
        fetchImageData: DogApiLive.fetchImageData(from:)
    )
    
    static let mock: DogApiClient = DogApiClient(
        fetchBreeds: {
            Breed.mockArray
        },
        fetchImageUrl: { breed in
            guard let url = Bundle.main.url(forResource: "jacopo", withExtension: "jpg"),
                  let imageData = try? Data(contentsOf: url) else {
                throw Error.invalidURL
            }
            
            return url
        }, fetchImageData: { url in
            guard let url = Bundle.main.url(forResource: "jacopo", withExtension: "jpg"),
                  let imageData = try? Data(contentsOf: url) else {
                throw Error.unknown("Unable to load mock image data")
            }
            
            return imageData
        }
    )
}

private enum DogApiLive {
    // Move this to custom image view
    static func fetchImageData(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0

        let session = URLSession(configuration: .ephemeral)
        let (data, _) = try await session.data(for: request)
        
        return data
    }
    
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
                throw DogApiClient.Error.responseError("The request failed: \(failure.message)")
            }
        } catch {
            Logger.networking.error("❌ Exception while fetching from url: \(url) with error: \(error.localizedDescription)")
            throw error
        }
    }
}
