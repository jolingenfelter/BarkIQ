//
//  ResultsView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI
import SwiftData

struct ResultsView: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(\.quizActions.restart)
    private var restart
    
    @Environment(\.quizActions.quit)
    private var quit
    
    @ScaledMetric(relativeTo: .largeTitle)
    private var verticalPadding = 8.0
    
    let results: [QuestionResult]
    
    init(results: [QuestionResult]) {
        self.results = results
    }
    
    var scoreText: String {
        let correctCount = results.filter(\.isCorrect).count
        let total = results.count
        
        return "\(correctCount)/\(total)"
    }
    
    var body: some View {
        // I was having trouble getting the fotter of a list to do
        // what I wanted it to do here, so I used a Form instead
        Form {
            Group {
                Text("You got ") +
                Text(scoreText).bold() +
                Text(" correct!")
            }
            .padding(.vertical, verticalPadding)
            
            Section {
                ForEach(results, id: \.self) { result in
                    NavigationLink {
                        QuestionView(result: result)
                    } label: {
                        HStack {
                            Text(result.question.answer.displayName)
                            Spacer()
                            ConfidenceIndicator(bool: result.isCorrect)
                        }
                        .padding(.vertical, verticalPadding)
                    }
                }
            } footer: {
                LoadingButton("Take another quiz!") {
                   restart()
                }
                .buttonStyle(.primary)
                .padding(.top, 28)
            }
        }
        .task {
            persistStats(from: results, in: modelContext)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    quit()
                }
            }
        }
        .navigationTitle("Score")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func persistStats(from results: [QuestionResult], in context: ModelContext) {
        for result in results {
            let breedName = result.question.answer.name

            let descriptor = FetchDescriptor<BreedStats>(predicate: #Predicate { $0.name == breedName })

            if let existing = try? context.fetch(descriptor).first {
                existing.update(for: result)
            } else {
                let newStats = BreedStats(breed: result.question.answer)
                newStats.update(for: result)
                context.insert(newStats)
            }
        }

        try? context.save()
    }
}

#Preview {
    NavigationStack {
        ResultsView(results: QuestionResult.mockArray)
    }
}
