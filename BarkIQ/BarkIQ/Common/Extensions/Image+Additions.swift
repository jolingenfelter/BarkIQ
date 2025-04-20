//
//  File.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import SwiftUI

extension Image {
    /// Initializes a SwiftUI `Image` from raw image `Data`.
    ///
    /// This is useful when loading image data manually (e.g., from a network request)
    /// and converting it into a SwiftUI-renderable `Image` without using `UIImage`.
    ///
    /// - Parameters:
    ///   - data: The raw image data.
    ///   - scale: The display scale to apply to the image. Defaults to 1.0.
    ///
    /// Returns `nil` if the data cannot be converted into a valid image. This is admittedly
    /// a little weird to use, but force unwrapping or throwing an error feels worse.
    init?(data: Data, scale: CGFloat = 1.0) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            return nil
        }
        
        self = Image(decorative: cgImage, scale: scale)
    }
}
