//
//  HomeView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.dogApiClient)
    private var apiClient
    
    @State private var isShowingSetupSheet = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 44) {
                        Text("BarkIQ")
                            .font(.system(.largeTitle, design: .monospaced))
                            .foregroundColor(.barkText)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 16) {
                            Button("Quiz me!") {
                                isShowingSetupSheet = true
                            }
                            .buttonStyle(.primary)
                            .accessibilityIdentifier("quiz-me-button")
                            
                            NavigationLink("Stats") {
                                BreedStatsListView()
                            }
                            .buttonStyle(.primary)
                            .accessibilityIdentifier("stats-button")
                        }
                    }
                    .scenePadding()
                    .frame(
                        minWidth: geometry.size.width,
                        minHeight: geometry.size.height,
                        alignment: .center
                    )
                }
            }
            .background(.barkBackground)
            .sheet(isPresented: $isShowingSetupSheet) {
                QuizFlow(apiClient: apiClient)
            }
        }
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
        HomeView()
    }
    .environment(\.dogApiClient, .mock)
    .modelContext(context)
}
