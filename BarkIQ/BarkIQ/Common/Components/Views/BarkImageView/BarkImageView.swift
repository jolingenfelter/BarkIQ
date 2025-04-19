//
//  BarkImageView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

// TODO: Add documentation for why AsyncImage will not work here
struct BarkImageView<Placeholder: View>: View {
    enum Phase: Equatable {
        case loading
        case loaded(Image)
        case error(String)
    }
    
    @ScaledMetric
    private var retrySpacing: CGFloat = 8
    
    @State
    private var phase: Phase = .loading
    
    @Environment(\.imageDataLoader)
    private var imageDataLoader: ImageDataLoader
    
    let url: URL?
    let placeholder: () -> Placeholder
    
    init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack {
            switch phase {
            case .loading:
                placeholder()
            case .loaded(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .error(let error):
                VStack(spacing: retrySpacing) {
                    Text("Error loading image: \(error)")
                    Button("Retry", systemImage: "arrow.clockwise") {
                        
                    }
                }
            }
        }
        .task {
            await fetchImage()
        }
        .onChange(of: url) { _ , newValue in
            Task {
                await fetchImage()
            }
        }
        .animation(.default, value: phase)
    }
    
    private func fetchImage() async {
        guard let url else {
            return
        }
        
        do {
            let data = try await imageDataLoader.fetchImageData(url)
            
            if let image = Image(data: data) {
                phase = .loaded(image)
            } else {
                phase = .error("Error converting data to image")
            }
        } catch {
            phase = .error(error.localizedDescription)
        }
    }
}

extension BarkImageView where Placeholder == DefaultImagePlaceholder {
    init(url: URL?) {
        self.init(
            url: url,
            placeholder: { DefaultImagePlaceholder() }
        )
    }
}

#Preview {
    BarkImageView(url: Bundle.main.url(forResource: "jacopo", withExtension: "jpg")!)
        .environment(\.imageDataLoader, ImageDataLoader.mock)
}
