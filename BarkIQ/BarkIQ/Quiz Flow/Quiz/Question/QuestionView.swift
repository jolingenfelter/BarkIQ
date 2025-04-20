//
//  QuizQuestionView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct QuestionView: View {
    enum QuestionStage: Equatable {
        case ask
        case showAnswer(_ isCorrect: Bool)
    }
    
    @ScaledMetric
    private var questionTextSpacing: CGFloat = 24
    
    @State
    private var questionStage: QuestionStage = .ask
    
    @State
    private var confirmationAlert: ConfirmationDialogModel?
    
    private var isShowingAnswer: Bool {
        guard case .showAnswer = questionStage else {
            return false
        }

        return true
    }
    
    private var backgroundColor: Color {
        switch questionStage {
        case .showAnswer(let isCorrect):
            return (isCorrect ? Color.green : Color.red).opacity(0.18)
        default:
            return .barkBackground
        }
    }
    
    let question: Question
    let answerAction: (Breed) -> Void
    let nextAction: () async -> Void
    let quitAction: () -> Void
    
    var body: some View {
        ScrollingContentView { geometry in
            VStack(spacing: questionTextSpacing) {
                BarkImageView(url: question.imageUrl)
                    .frame(height: geometry.size.height * 0.35)
                    .frame(maxWidth: .infinity)
                
                Text(question.questionText)
                    .font(.system(.body, design: .monospaced).bold())
                
                VStack(spacing: 48) {
                    AnswerPicker(
                        choices: question.choices,
                        correctAnswer: question.answer,
                        questionStage: $questionStage,
                        selectChoiceAction: answerAction
                    )
                    
                    // Some sort of "continue" action
                    // to handle ending a quiz
                    if isShowingAnswer {
                        LoadingButton("Next") {
                            await nextAction()
                        }
                        .buttonStyle(.primary)
                        .transition(.slide)
                    }
                }
            }
            .scenePadding()
            .animation(.spring, value: isShowingAnswer)
        }
        .background(backgroundColor)
        .navigationBarBackButtonHidden()
        .interactiveDismissDisabled()
        .navigationTitle(question.location.displayText)
        .navigationBarTitleDisplayMode(.large)
         .confirmationDialog($confirmationAlert)
    }
    
    private func quitConfirmation() -> ConfirmationDialogModel {
        let action = ConfirmationDialogModel.Action(
            "Quit now",
            role: .destructive,
            action: quitAction
        )
        
        let model = ConfirmationDialogModel(
            title: "Are you sure you want to quit?",
            message: "Your results will not be saved.",
            actions: [action]
        )
        return model
    }
}

#Preview {
    QuestionView(
        question: .mock(),
        answerAction: { _ in },
        nextAction: {},
        quitAction: {}
    )
}
