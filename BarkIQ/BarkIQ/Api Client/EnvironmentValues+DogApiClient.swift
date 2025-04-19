//
//  EnvironmentValues+DogApiClient.swift.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

private struct DogApiClientKey: EnvironmentKey {
    static let defaultValue: DogApiClient = .live
}

extension EnvironmentValues {
    var dogApiClient: DogApiClient {
        get { self[DogApiClientKey.self] }
        set { self[DogApiClientKey.self] = newValue }
    }
}
