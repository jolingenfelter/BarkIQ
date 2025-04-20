//
//  QuizView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct QuizView: View {
    @Environment(QuizController.self)
    private var quizController
    
    @State
    private var confirmationAlert: ConfirmationDialogModel?
    
    let nextQuestion: () -> Void
    let showResults: () -> Void
    let quitAction: () -> Void
    
    var body: some View {
        Color.blue
//        QuestionView(
//            question: question,
//            answerAction: quizController.checkAnswer(selected:),
//            nextAction: nextQuestion,
//        )
//        .transition(.opacity)
//        .animation(.default, value: quizController.currentState)
//        .task {
//            await quizController.next()
//        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Quit") {
//                    confirmationAlert = quitConfirmation()
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//        .interactiveDismissDisabled()
//        .navigationTitle(quizController.progressDisplay)
//        .navigationBarTitleDisplayMode(.large)
//        .confirmationDialog($confirmationAlert)
//        .background(Color.barkBackground)
    }
    
    private func quitConfirmation() -> ConfirmationDialogModel {
        let action = ConfirmationDialogModel.Action("Quit now", role: .destructive, action: quitAction)
        let model = ConfirmationDialogModel(
            title: "Are you sure you want to quit?",
            message: "Your results will not be saved.",
            actions: [action]
        )
        return model
    }
}
//
//#Preview {
//    QuizView(
//        nextQuestion: {},
//        showResults: {},
//        quitAction: {}
//    )
//    .environment(QuizController.mock)
//    .environment(\.imageDataLoader, .mock)
//}
