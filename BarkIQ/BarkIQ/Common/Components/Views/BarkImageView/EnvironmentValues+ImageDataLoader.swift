//
//  EnvironmentValues+ImageDataLoader.swift.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

private struct ImageDataLoaderKey: EnvironmentKey {
    static let defaultValue: ImageDataLoader = .live
}

extension EnvironmentValues {
    var imageDataLoader: ImageDataLoader {
        get { self[ImageDataLoaderKey.self] }
        set { self[ImageDataLoaderKey.self] = newValue }
    }
}
