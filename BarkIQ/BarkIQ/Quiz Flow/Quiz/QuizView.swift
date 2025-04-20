//
//  QuizView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct QuizView: View {
    @State
    private var quizController: QuizController
    
    @State
    private var confirmationAlert: ConfirmationDialogModel?
    
    let showResults: () -> Void
    let quitAction: () -> Void
    
    init(
        settings: QuizSettings,
        apiClient: DogApiClient,
        showResults: @escaping () -> Void,
        quitAction: @escaping () -> Void
    ) {
        _quizController = State(wrappedValue: QuizController(settings: settings, apiClient: apiClient))
        self.showResults = showResults
        self.quitAction = quitAction
    }
    
    var body: some View {
        Group {
            switch quizController.currentStep {
            case .question(let question):
                QuestionView(
                    question: question,
                    answerAction: quizController.checkAnswer(selected:),
                    nextAction: quizController.next
                )
            case .error(let error):
                ErrorView(
                    error: error,
                    retryAction: quizController.next
                )
            default:
                LoadingView()
            }
        }
        .task {
            await quizController.next()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Quit") {
                    confirmationAlert = quitConfirmation()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .interactiveDismissDisabled()
        .navigationTitle(quizController.progressDisplay)
        .confirmationDialog($confirmationAlert)
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

#Preview {
    QuizView(
        settings: .mock,
        apiClient: .mock,
        showResults: {},
        quitAction: {}
    )
    .environment(\.imageDataLoader, .mock)
    .environment(\.dogApiClient, .mock)
}
