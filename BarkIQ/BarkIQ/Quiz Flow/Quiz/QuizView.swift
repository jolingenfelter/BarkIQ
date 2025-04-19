//
//  QuizView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct QuizView: View {
    @ScaledMetric
    private var questionTextSpacing: CGFloat = 24
    
    @State
    private var quizController: QuizController
    
    @State
    private var confirmationAlert: ConfirmationDialogModel?
    
    let showResults: () -> Void
    let quitAction: () -> Void
    
    init(
        settings: QuizSettings,
        showResults: @escaping () -> Void,
        quitAction: @escaping () -> Void
    ) {
        _quizController = State(wrappedValue: QuizController(settings: settings))
        self.showResults = showResults
        self.quitAction = quitAction
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: questionTextSpacing) {
                    BarkImageView(url: quizController.currentQuestion.imageUrl)
                        .frame(
                            maxWidth: geometry.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing,
                            minHeight: geometry.size.height * 0.3,
                            maxHeight: geometry.size.height * 0.4
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text(quizController.currentQuestion.questionText)
                        .font(.system(.body, design: .monospaced).bold())
                    
                    VStack(spacing: 16) {
                        ForEach(quizController.currentQuestion.choices, id: \.self) { breed in
                            Button(breed.displayName) {
                                
                            }
                            .buttonStyle(.secondary)
                        }
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Quit") {
                            confirmationAlert = quitConfirmation()
                        }
                    }
                }
                .scenePadding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarBackButtonHidden()
                .interactiveDismissDisabled()
                .navigationTitle("1/5")
                .confirmationDialog($confirmationAlert)
            }
        }
        .background(Color.barkBackground)
    }
    
    private func quitConfirmation() -> ConfirmationDialogModel {
        let action = ConfirmationDialogModel.Action("Quit now", role: .destructive, action: quitAction)
        let model = ConfirmationDialogModel(title: "Are you sure you want to quit?", message: "Your results will not be saved.", actions: [action])
        return model
    }
}

#Preview {
    QuizView(
        settings: .mock,
        showResults: {},
        quitAction: {}
    )
    .environment(\.imageDataLoader, .mock)
}
