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
    
    private let phaseTransitionAnimation = Animation.spring(
            response: 0.4,
            dampingFraction: 0.75,
            blendDuration: 0.2
    )
    
    let url: URL?
    let cornerRadius: CGFloat
    let placeholder: () -> Placeholder
    
    init(
        url: URL?,
        cornerRadius: CGFloat = 12,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.cornerRadius = cornerRadius
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            switch phase {
            case .loading:
                placeholder()
            case .loaded(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .error(let error):
                VStack(spacing: retrySpacing) {
                    Text("Error loading image: \(error)")
                    RetryButton {
                        await fetchImage()
                    }
                }
            }
        }
        .transition(
            .asymmetric(
                insertion: .scale(scale: 0.9).combined(with: .opacity),
                removal: .opacity
            )
        )
        .cornerRadius(cornerRadius)
        .task {
            await fetchImage()
        }
        .onChange(of: url) { _ , newValue in
            if newValue == nil {
                phase = .loading
            } else {
                Task {
                    await fetchImage()
                }
            }
        }
    }
    
    private func fetchImage() async {
        guard let url else {
            return
        }
        
        do {
            let data = try await imageDataLoader.fetchImageData(url)
            
            // TODO: Add comments
            if let image = Image(data: data) {
                withAnimation(phaseTransitionAnimation) {
                    phase = .loaded(image)
                }
            } else {
                withAnimation(phaseTransitionAnimation) {
                    phase = .error("Error converting data to image")
                }
                
            }

        } catch {
            withAnimation(phaseTransitionAnimation) {
                phase = .error(error.localizedDescription)
            }
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
