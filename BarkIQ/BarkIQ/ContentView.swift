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
    @State private var imageData: Data?
    
    var body: some View {
        ScrollView {
            VStack {
                if let imageData, let image = Image(data: imageData) {
                    image
                        .resizable()
                        .scaledToFill()
                        .background(Color.blue)
                }
                
                Text(result)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .scenePadding()
        }
        .task {
            do {
                let imageData = try await DogApiClient.fetchImageData(for: Breed(name: "dachshund"))
                self.imageData = imageData
                
                let breeds = try await DogApiClient.fetchBreeds()
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
