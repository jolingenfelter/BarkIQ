//
//  BreedStatsListView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI
import SwiftData

struct BreedStatsListView: View {
    @Query var stats: [BreedStats]
    
    var body: some View {
        List(stats, id: \.name) { stat in
            NavigationLink {
                BreedStatsDetailView(stats: stat)
            } label: {
                HStack {
                    Text(stat.displayName)
                    Spacer()
                    ScoreIndicator(level: stat.confidence)
                }
                
            }
            
        }
        .navigationTitle("Stats by breed")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)

    let container = try! ModelContainer(
        for: BreedStats.self,
        configurations: config
    )
    let context = ModelContext(container)

    populatePreviewData(in: context)

    return NavigationStack {
        BreedStatsListView()
    }
    .modelContext(context)
}
