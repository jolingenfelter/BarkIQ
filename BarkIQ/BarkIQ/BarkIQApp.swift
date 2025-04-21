//
//  BarkIQApp.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/13/25.
//

import SwiftUI
import SwiftData

@main
struct BarkIQApp: App {
    
    init() {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-ui-tests") {
            UIView.setAnimationsEnabled(false)
        }
        #endif
    }
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.dogApiClient, resolvedDogApiClient)
                .environment(\.imageDataLoader, resolvedImageLoader)
        }
        .modelContainer(for: [BreedStats.self])
    }
    
    
    private var resolvedDogApiClient: DogApiClient {
        #if DEBUG
        if CommandLine.arguments.contains("-use-mock-api") {
            return .mock
        }
        #endif
        return .live
    }
    
    private var resolvedImageLoader: ImageDataLoader {
        #if DEBUG
        if CommandLine.arguments.contains("-use-mock-api") {
            return .mock
        }
        #endif
        return .live
    }
}
