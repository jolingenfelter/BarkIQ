//
//  ImageDataLoader.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI
import OSLog

/// A lightweight dependency that defines how image data should be fetched for a given URL.
///
/// `ImageDataLoader` allows clients to inject different image loading strategies,
/// making it easy to customize behavior for production, testing, and previews.
struct ImageDataLoader {
    /// The core loading function that fetches image data for a given URL.
    let fetchImageData: (URL) async throws -> Data
    
    static let live = ImageDataLoader { url in
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        
        // Use `.ephemeral` to avoid persistent connection
        // issues (e.g. QUIC errors from dog.ceo API)
        let session = URLSession(configuration: .ephemeral)
        
        Logger.imageLoading.info("⌛️ Loading image data for \(url)")
        let (data, _) = try await session.data(for: request)
        Logger.imageLoading.info("🌠 Received image data from \(url)")
        return data
    }
    
    static let failing = ImageDataLoader { url in
        throw URLError(.badServerResponse)
    }
    
    static let mock = ImageDataLoader { url in
        guard let mockURL = Bundle.main.url(forResource: "jacopo", withExtension: "jpg"),
              let data = try? Data(contentsOf: mockURL)
        else {
            throw URLError(.fileDoesNotExist)
        }
        
        try? await Task.sleep(for: .seconds(2.0))
        
        return data
    }
}
