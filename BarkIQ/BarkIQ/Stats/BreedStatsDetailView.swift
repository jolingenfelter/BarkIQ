//
//  BreedStatsDetailView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI
import SwiftData

/// A detail view that shows quiz performance for a specific breed.
/// Displays streaks, answer history, and other stats from `BreedStats`.
/// The first item in this view is the `Confidence` level for the selected
/// breed.  See `BreedStats.confidece` for more information on how
/// this is defined.
struct BreedStatsDetailView: View {
    @ScaledMetric(relativeTo: .largeTitle)
    private var verticalPadding = 8.0
    
    let stats: BreedStats

    var body: some View {
        List {
            Section("Repetitions and Accuracy") {
                HStack {
                    Text("Confidence")
                    Spacer()
                    ConfidenceIndicator(level: stats.confidence)
                }
                .padding(.vertical, verticalPadding)
                .accessibilityElement()
                .accessibilityLabel("Confidence - \(stats.confidence.rawValue). \(axConfidenceAdendum(for: stats))")

                row(
                    title: "Reps",
                    content: String(stats.repetitionCount)
                )

                row(title: "Accuracy",
                    content: String(stats.accuracy.formatted(.percent.precision(.fractionLength(0))))
                )

                row(
                    title: "Correct Reps",
                    content: String(stats.correctCount)
                )

                row(
                    title: "Incorrect Reps",
                    content: String(stats.incorrectCount)
                )

            }

            Section("Streaks") {
                row(
                    title: "Current streak",
                    content: String(stats.streak)
                )
                row(
                    title: "Longest streak",
                    content: String(stats.longestRunningStreak)
                )
            }

            Section("History") {
                if let lastCorrectDate = stats.lastCorrectDate {
                    row(
                        title: "Last correct",
                        content: lastCorrectDate.formatted(date: .abbreviated, time: .shortened))
                }

                if let lastInCorrectDate = stats.lastInCorrectDate {
                    row(
                        title: "Last incorrect",
                        content: lastInCorrectDate.formatted(date: .abbreviated, time: .shortened))
                }
                
                if !stats.mistakes.isEmpty {
                    NavigationLink {
                        MistakesListView(
                            breedName: stats.displayName,
                            mistakesHistory: stats.mistakes
                        )
                    } label: {
                        row(title: "Mistaken for", content: nil)
                    }
                }
            }
        }
        .navigationTitle("\(stats.displayName)")
    }

    @ViewBuilder
    private func row(title: String, content: String?) -> some View {
        ViewThatFits {
            HStack {
                Text(title)
                Spacer(minLength: 8)

                if let content {
                    Text(content)
                        .frame(alignment: .trailing)
                }
            }
            
            VStack(alignment: .leading) {
                Text(title)
                Spacer(minLength: verticalPadding)

                if let content {
                    Text(content)
                }
            }
        }
        .padding(.vertical, verticalPadding)
        .accessibilityElement(children: .combine)
    }
    
    private func axConfidenceAdendum(for stats: BreedStats) -> String {
        switch stats.confidence {
        case .high:
            return "You usually get this one right."
        case .medium:
            return "You get this one right sometimes, but you haven't mastered it yet."
        case .low:
            return "You need to practice more to get this one right."
        }
    }
}

#Preview {
    NavigationStack {
        BreedStatsDetailView(stats: .mockLowConfidence1)
    }
}
