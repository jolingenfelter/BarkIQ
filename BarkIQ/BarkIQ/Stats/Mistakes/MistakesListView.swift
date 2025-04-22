//
//  MistakesListView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import SwiftUI

/// Shows a list of the breeds that a particular breed has been mistaken
/// for in quizzes grouped by the date of those mistakes
struct MistakesListView: View {
    @ScaledMetric(relativeTo: .largeTitle)
    private var verticalPadding = 8

    let breedName: String
    let mistakesHistory: [Date: String]
    
    private var sectionedMistakes: [String: [String]] {
        MistakeGrouping.groupMistakesByDate(mistakesHistory)
    }

    var body: some View {
        List {
            ForEach(sectionedMistakes.sorted(by: { $0.key > $1.key }), id: \.key) { dateString, mistakes in
                Section(dateString) {
                    ForEach(MistakeGrouping.groupedMistakes(from: mistakes), id: \.breed) { (breed, count) in
                        ViewThatFits {
                            HStack {
                                rowContent(breed: breed, count: count)
                            }
                            VStack(alignment: .leading) {
                                rowContent(breed: breed, count: count)
                            }
                        }
                        .padding(.vertical, verticalPadding)
                        .accessibilityElement(children: .combine)
                    }
                }
            }
        }
        .navigationTitle("\(breedName) Mistakes")
        .navigationBarTitleDisplayMode(.large)
    }

    private func rowContent(breed: String, count: Int) -> some View {
        Group {
            Text(breed)
            Spacer()
            Text("\(count)").foregroundStyle(.secondary)
        }
    }
}

#Preview {
    MistakesListView(
        breedName: "Pug",
        mistakesHistory: [
           Date().addingTimeInterval(-1000): "Poodle",
           Date().addingTimeInterval(-2000): "Golden Retriever",
           Date().addingTimeInterval(-3000): "Poodle",
           Date().addingTimeInterval(-4000): "Beagle",
           Date().addingTimeInterval(-5000): "Golden Retriever",
           Date().addingTimeInterval(-6000): "Golden Retriever"
       ]
    )
}
