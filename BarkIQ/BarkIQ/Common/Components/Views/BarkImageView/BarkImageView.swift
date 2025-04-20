//
//  BarkImageView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

/// Custom image view used instead of `AsyncImage` because:
/// - `AsyncImage` uses a shared `URLSession`, which frequently fails for this API
/// - A `.ephemeral` session is required to avoid persistent QUIC-related connection issues
/// - This view allows full control over loading, animated transitions, and error handling
/// - Supports custom placeholders and consistent styling across app use cases
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
    
    /// The image URL to load. If `nil`, the placeholder will be shown.
    let url: URL
    
    /// The corner radius to apply directly to the image view.
    ///
    /// Note: This must be set during initialization. Applying `.cornerRadius`
    /// externally (to the container of this view) may result in incorrect rendering,
    /// especially if the image is smaller than its parent frame.
    let cornerRadius: CGFloat
    
    /// A view builder that returns a placeholder to be shown while the image loads
    /// or when the URL is `nil`.
    let placeholder: () -> Placeholder
    
    /// Initializes a `BarkImageView` with a URL, optional corner radius,
    /// and a placeholder view to show while loading or on error.
    ///
    /// - Parameters:
    ///   - url: The remote image URL to load.
    ///   - cornerRadius: The corner radius applied directly to the image. Defaults to 12.
    ///   - placeholder: A view shown while loading or when the image cannot be loaded.
    init(
        url: URL,
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
            Task {
                await fetchImage()
            }
        }
    }
    
    private func fetchImage() async {
        do {
            let data = try await imageDataLoader.fetchImageData(url)
        
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
    init(url: URL) {
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
