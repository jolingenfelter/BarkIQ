//
//  QuizSetupView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

/// The first view in the quiz flow, which allows the user to select
/// the number of questions in their quiz. The "Start Quiz" button
/// calls `next()` from the `QuizFlowActions` in the
/// environment to begin the quiz.
struct QuizSetupView: View {
    @Environment(\.quizFlowActions)
    private var quizFlowActions
    
    @State private var isShowingQuestion: Bool = false
    @State private var error: AlertModel?
    
    @Binding var settings: QuizSettings
    
    var body: some View {
        Form {
            Section {
                Picker("Question count", selection: $settings.questionCount) {
                    ForEach(settings.countOptions, id: \.self) { option in
                        Text("\(option)")
                            .tag(option)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("question-count-picker")
            } footer: {
                LoadingButton("Start Quiz!") {
                    await quizFlowActions.next?()
                }
                .buttonStyle(.primary)
                .padding(.top, 28)
            }
        }
        .navigationTitle(Text("Quiz Settings"))
    }
    
    private func errorAlert(_ error: Error) -> AlertModel {
        let okAction = AlertModel.Action.ok {
            quizFlowActions.quit?()
        }
        
        let alert = AlertModel(
            title: "Error",
            message: "Unable create quiz: \(error.localizedDescription)",
            actions: [okAction]
        )
        
        return alert
    }
}

#Preview {
    QuizSetupView(settings: .constant(.mock))
        .environment(\.quizFlowActions, .mock)
}
