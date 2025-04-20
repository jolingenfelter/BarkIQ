//
//  ResultsView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct ResultsView: View {
    let results: [QuestionResult]
    
    init(results: [QuestionResult]) {
        self.results = results
    }
    
    var titleText: String {
        let correctCount = results.filter(\.isCorrect).count
        let total = results.count
        
        return "Score \(correctCount)/\(total)"
    }
    
    var body: some View {
        Form {
            Section {
                ForEach(results, id: \.self) { result in
                    NavigationLink {
                        Text("Hello")
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
                   
                }
                .buttonStyle(.primary)
                .padding(.top, 28)
            }
        }
        .navigationTitle(titleText)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        ResultsView(results: QuestionResult.mockArray)
    }
}
