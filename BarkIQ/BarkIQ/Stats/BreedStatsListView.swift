//
//  BreedStatsListView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI
import SwiftData

struct BreedStatsListView: View {
    @Query(sort: [SortDescriptor(\BreedStats.displayName)]) var stats: [BreedStats]
    
    @ScaledMetric(relativeTo: .largeTitle)
    private var verticalPadding = 8.0
    
    var body: some View {
        Group {
            if stats.isEmpty {
                emptyState()
            } else {
                List(stats, id: \.name) { stat in
                    NavigationLink {
                        BreedStatsDetailView(stats: stat)
                    } label: {
                        HStack {
                            Text(stat.displayName)
                            Spacer(minLength: 8)
                            ConfidenceIndicator(level: stat.confidence)
                        }
                        .padding(.vertical, verticalPadding)
                        .accessibilityElement(children: .combine)
                    }
                }
            }
        }
        .navigationTitle("Stats by breed")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func emptyState() -> some View {
        ScrollingContentView { geometry in
            Text("Take a quiz and then come here to see your stats!")
                .frame(
                    maxWidth: geometry.size.width,
                    minHeight: geometry.size.height
                )
                .padding(.horizontal, 40)
                .scenePadding()
        }
        .background(Color(UIColor.systemGroupedBackground))
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
