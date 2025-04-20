//
//  BreedStatsListView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI
import SwiftData

struct BreedStatsListView: View {
    @Query(sort: [SortDescriptor(\BreedStats.name)]) var stats: [BreedStats]
    
    var body: some View {
        List(stats, id: \.name) { stat in
            NavigationLink {
                BreedStatsDetailView(stats: stat)
            } label: {
                HStack {
                    Text(stat.displayName)
                    Spacer(minLength: 8)
                    ConfidenceIndicator(level: stat.confidence)
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
    
    for stats in BreedStats.mockCollection {
        context.insert(stats)
    }

    return NavigationStack {
        BreedStatsListView()
    }
    .modelContext(context)
}
