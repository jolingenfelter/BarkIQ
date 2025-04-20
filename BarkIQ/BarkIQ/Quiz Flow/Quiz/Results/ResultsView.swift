//
//  ResultsView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct ResultsView: View {
    @Environment(\.quizActions.restart)
    private var restart
    
    @Environment(\.quizActions.quit)
    private var quit
    
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
        Form {
            Text("You got ") +
            Text(scoreText).bold() +
            Text(" correct!")
            
            Section {
                ForEach(results, id: \.self) { result in
                    NavigationLink {
                        QuestionView(result: result)
                    } label: {
                        HStack {
                            Text(result.question.answer.displayName)
                            Spacer()
                            ScoreIndicator(bool: result.isCorrect)
                        }
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    quit()
                }
            }
        }
        .navigationTitle("Score")
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        ResultsView(results: QuestionResult.mockArray)
    }
}
