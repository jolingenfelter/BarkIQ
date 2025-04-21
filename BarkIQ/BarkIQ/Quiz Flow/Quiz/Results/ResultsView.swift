//
//  ResultsView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI
import SwiftData
import OSLog

struct ResultsView: View {
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(\.quizFlowActions.restart)
    private var restart
    
    @Environment(\.quizFlowActions.quit)
    private var quit
    
    @ScaledMetric(relativeTo: .largeTitle)
    private var verticalPadding = 8.0
    
    let results: [QuestionResult]
    
    init(results: [QuestionResult]) {
        self.results = results
    }
    
    private var correctCount: Int {
        results.filter(\.isCorrect).count
    }
    
    private var scoreText: String {
        let total = results.count
        
        return "\(correctCount)/\(total)"
    }
    
    var body: some View {
        // Some challenges getting the footer of a list to do what I what
        // I wanted so I used a form.  Need to do more testing with the
        // List component.
        Form {
            Group {
                Text("You got ") +
                Text(scoreText).bold() +
                Text(" correct!")
            }
            .padding(.vertical, verticalPadding)
            .accessibilityLabel("You got \(correctCount) of \(results.count) correct!")
            
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
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(result.question.answer.displayName) – \(result.isCorrect ? "Correct" : "Incorrect")")
                    }
                }
            } footer: {
                LoadingButton("Take another quiz!") {
                    restart?()
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
                Button("Close") {
                    quit?()
                }
                .accessibilityIdentifier("close-button")
            }
        }
        .navigationTitle("Score")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func persistStats(from results: [QuestionResult], in context: ModelContext) {
        Logger.persistence.info("📊 Beginning breed stats update...")
        
        for result in results {
            let breedName = result.question.answer.name
            
            let descriptor = FetchDescriptor<BreedStats>(
                predicate: #Predicate { $0.name == breedName }
            )
            
            do {
                if let existing = try context.fetch(descriptor).first {
                    Logger.persistence.info("🔄 Updating stats for breed: \(existing.displayName)")
                    existing.update(for: result)
                } else {
                    Logger.persistence.info("🆕 Inserting stats for breed: \(result.question.answer.displayName)")
                    let newStats = BreedStats(breed: result.question.answer)
                    newStats.update(for: result)
                    context.insert(newStats)
                }
            } catch {
                Logger.persistence.error("❌ Error fetching stats for breed '\(breedName)':\n\(error)")
            }
        }

        do {
            try context.save()
            Logger.persistence.info("💾 Successfully saved updated stats.")
        } catch {
            Logger.persistence.error("❌ Error saving context:\n\(error)")
        }
    }
}

#Preview {
    NavigationStack {
        ResultsView(results: QuestionResult.mockArray)
    }
}
