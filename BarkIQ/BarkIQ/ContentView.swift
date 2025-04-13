//
//  ContentView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        Text("Hello world!")
            .task {
                let apiClient = DogAPIClient()
                
                do {
                    let _ = try await apiClient.fetchBreeds()
                } catch {
                    print(error)
                }
            }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
