//
//  ContentView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var result: String = ""
    var body: some View {
        Text(result)
            .task {
                let apiClient = DogAPIClient()
                
                do {
                    let breeds = try await apiClient.fetchBreeds()
                    result = breeds.map(\.displayName).joined(separator: ", ")
                } catch {
                    result = "Error: \(error.localizedDescription)"
                }
            }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
