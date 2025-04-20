//
//  QuizSetupView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct QuizSetupView: View {
    @State private var isShowingQuestion: Bool = false
    @State private var error: AlertModel?
    
    @Binding var settings: QuizSettings
    let startQuizAction: () async -> Void
    let dismissAction: () -> Void
    
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
                    await startQuizAction()
                }
                .buttonStyle(.primary)
                .padding(.top, 28)
            }
        }
        .navigationTitle(Text("Quiz Settings"))
    }
    
    private func errorAlert(_ error: Error) -> AlertModel {
        let okAction = AlertModel.Action.ok {
            dismissAction()
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
    QuizSetupView(
        settings: .constant(.mock),
        startQuizAction: {},
        dismissAction: {}
    )
}
