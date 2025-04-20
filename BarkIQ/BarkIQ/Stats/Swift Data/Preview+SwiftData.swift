//
//  Preview+SwiftData.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: BreedStats.self,  // add more model types here if needed
            configurations: config
        )
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()

func populatePreviewData(in context: ModelContext) {
    let stat = BreedStats(breed: .mock1)
    stat.appendCorrectResponse()
    context.insert(stat)
    
    let another = BreedStats(breed: .mock2)
    another.incorrectResponse()
    context.insert(another)
}
