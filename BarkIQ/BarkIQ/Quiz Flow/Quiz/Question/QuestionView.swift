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
        case showAnswer(_ result: QuestionResult)
    }
    
    @Environment(\.quizActions)
    private var quizActions
    
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
        case .showAnswer(let result):
            return (result.isCorrect ? Color.green : Color.red).opacity(0.18)
        default:
            return .barkBackground
        }
    }
    
    private var nextButtonText: String {
        question.location.isAtEnd ? "See results" : "Next"
    }
    
    let question: Question
    
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
                        questionStage: $questionStage,
                        question: question
                    )
                    
                    if isShowingAnswer {
                        LoadingButton(nextButtonText) {
                            await quizActions.next()
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
            action: quizActions.quit
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
    QuestionView(question: .mock())
}
