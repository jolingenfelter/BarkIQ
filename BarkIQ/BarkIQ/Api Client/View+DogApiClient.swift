//
//  View+DogApiClient.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

private struct DogApiClientKey: EnvironmentKey {
    static let defaultValue: DogApiClient = .mock
}

extension EnvironmentValues {
    var dogApiClient: DogApiClient {
        get { self[DogApiClientKey.self] }
        set { self[DogApiClientKey.self] = newValue }
    }
}

extension View {
    func dogApiClient(_ client: DogApiClient) -> some View {
        environment(\.dogApiClient, client)
    }
}
