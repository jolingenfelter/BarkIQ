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
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
