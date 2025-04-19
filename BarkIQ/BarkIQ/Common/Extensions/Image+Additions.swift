//
//  File.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import SwiftUI

extension Image {
    init?(data: Data, scale: CGFloat = 1.0) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            return nil
        }
        
        self = Image(decorative: cgImage, scale: scale)
    }
}
