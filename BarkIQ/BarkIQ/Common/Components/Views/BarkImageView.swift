//
//  BarkImageView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

// TODO: Add documentation for why AsyncImage will not work here
struct BarkImageView: View {
    enum Phase: Equatable {
        case loading
        case loaded(Image)
        case error(String)
    }
    
    @State
    private var phase: Phase = .loading
    
    @ScaledMetric(relativeTo: .largeTitle)
    private var retrySpacing: CGFloat = 8
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        ZStack {
            switch phase {
            case .loading:
                ProgressView()
            case .loaded(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .error(let error):
                VStack(spacing: retrySpacing) {
                    Text(error)
                    Button("Retry", systemImage: "arrow.clockwise") {
                        Task {
                            await fetchImage()
                        }
                    }
                }
            }
        }
        .task {
            await fetchImage()
        }
        .animation(.default, value: phase)
    }
    
    private func fetchImage() async {
        do {
            let data = try await fetchImageData(from: url)
            
            if let image = Image(data: data) {
                phase = .loaded(image)
            } else {
                phase = .error("Error converting data to image")
            }
        } catch {
            phase = .error(error.localizedDescription)
        }
    }
    
    private func fetchImageData(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0

        // TODO: Add a comment to explain this
        let session = URLSession(configuration: .ephemeral)
        let (data, _) = try await session.data(for: request)
        
        return data
    }
    
}

#Preview {
    BarkImageView(url: Bundle.main.url(forResource: "jacopo", withExtension: "jpg")!)
}
