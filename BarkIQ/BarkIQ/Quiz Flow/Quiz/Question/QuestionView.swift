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
    
    enum Mode {
        case review
        case play
    }
    
    @Environment(\.quizActions)
    private var quizActions
    
    @ScaledMetric
    private var questionTextSpacing: CGFloat = 24
    
    @State
    private var questionStage: QuestionStage
    
    @State
    private var confirmationAlert: ConfirmationDialogModel?
    
    private var isShowingAnswer: Bool {
        guard case .showAnswer = questionStage else {
            return false
        }

        return true
    }
    
    private var titleText: String {
        switch mode {
        case .review:
            "#\(question.location.questionNumber)"
        case .play:
            question.location.displayText
        }
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
    
    private let mode: Mode
    
    let question: Question
    
    init(question: Question) {
        self.question = question
        self.mode = .play
        _questionStage = State(wrappedValue: .ask)
    }
    
    init(result: QuestionResult) {
        self.question = result.question
        self.mode = .review
        _questionStage = State(wrappedValue: .showAnswer(result))
    }
    
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
                    
                    if isShowingAnswer && mode == .play {
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
        .toolbar {
            if mode == .play {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Quit") {
                        confirmationAlert = quitConfirmation()
                    }
                }
            }
        }
        .background(backgroundColor)
        .navigationBarBackButtonHidden(mode == .play)
        .navigationTitle(titleText)
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
