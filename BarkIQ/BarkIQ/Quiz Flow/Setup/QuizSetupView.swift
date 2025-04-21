//
//  QuizSetupView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

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
            } footer: {
                LoadingButton("Start Quiz!") {
                    await quizFlowActions.next()
                }
                .buttonStyle(.primary)
                .padding(.top, 28)
            }
        }
        .navigationTitle(Text("Quiz Settings"))
    }
    
    private func errorAlert(_ error: Error) -> AlertModel {
        let okAction = AlertModel.Action.ok {
            quizFlowActions.quit()
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
}
