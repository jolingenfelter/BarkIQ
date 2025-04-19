//
//  QuizView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct QuizView: View {
    enum QuestionStage: Equatable {
        case ask
        case showAnswer(_ isCorrect: Bool)
    }
    
    @ScaledMetric
    private var questionTextSpacing: CGFloat = 24
    
    @State
    private var quizController: QuizController
    
    @State
    private var questionStage: QuestionStage = .ask
    
    @State
    private var confirmationAlert: ConfirmationDialogModel?
    
    private var backgroundColor: Color {
        switch questionStage {
        case .ask:
            return .barkBackground
        case .showAnswer(let isCorrect):
            return (isCorrect ? Color.green : Color.red).opacity(0.25)
        }
    }
    
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
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: questionTextSpacing) {
                    BarkImageView(url: quizController.imageUrl)
                    .frame(
                        maxWidth: geometry.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing,
                        minHeight: geometry.size.height * 0.3,
                        maxHeight: geometry.size.height * 0.4
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    if let questionText = quizController.questionText {
                        Text(questionText)
                            .font(.system(.body, design: .monospaced).bold())
                    }
                    
                    VStack(spacing: 16) {
                        ForEach(quizController.choices) { breed in
                            Button(breed.displayName) {
                                let isCorrect = quizController.checkAnswer(selected: breed)
                                
                                questionStage = .showAnswer(isCorrect)
                            }
                            .buttonStyle(.secondary)
                        }
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
                .scenePadding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarBackButtonHidden()
                .interactiveDismissDisabled()
                .navigationTitle(quizController.progressDisplay)
                .animation(.default, value: questionStage)
                .confirmationDialog($confirmationAlert)
            }
        }
        .background(backgroundColor)
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
        apiClient: .mock,
        showResults: {},
        quitAction: {}
    )
    .environment(\.imageDataLoader, .mock)
}
