//
//  BreedStatsDetailView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI
import SwiftData

struct BreedStatsDetailView: View {
    let stats: BreedStats

    var body: some View {
        List {
            Section("Repetitions and Accuracy") {
                HStack {
                    Text("Confidence")
                    Spacer()
                    ConfidenceIndicator(level: stats.confidence)
                }

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
            }
        }
        .navigationTitle("\(stats.displayName) Stats")
    }

    @ViewBuilder
    private func row(title: String, content: String?) -> some View {
        HStack {
            Text(title)
            Spacer()

            if let content {
                Text(content)
            }
        }
    }
}

#Preview {
    NavigationStack {
        BreedStatsDetailView(stats: .mockLowConfidence1)
    }
}
