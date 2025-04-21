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
    
    enum ScrollTarget: Hashable {
        case nextButton
    }
    
    @Environment(\.quizFlowActions)
    private var quizFlowActions
    
    @ScaledMetric(relativeTo: .largeTitle)
    private var questionTextSpacing: CGFloat = 24
    
    @State
    private var questionStage: QuestionStage
    
    @State
    private var confirmationAlert: ConfirmationDialogModel?
    
    @State
    private var shouldScrollToNext = false
    
    private var isShowingAnswer: Bool {
        guard case .showAnswer = questionStage else {
            return false
        }

        return true
    }
    
    private var showNextButton: Bool {
        isShowingAnswer && mode == .play
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
    
    private var nextButtonIdentifier: String {
        question.location.isAtEnd ? "see-results-button" : "next-question-button"
    }
    
    private let mode: Mode
    
    let question: Question
    
    /// Initialize a `QuestionView` in an interactive game-mode
    /// as part of a quiz.
    init(question: Question) {
        self.question = question
        self.mode = .play
        _questionStage = State(wrappedValue: .ask)
    }
    
    /// Initialize a `QuestionView` from a `QuestionResult` to put the view
    /// in a read-only mode that shows a selection in context of whether it was
    /// right or wrong.  Note when initialized this way, this view is not interactable
    /// and the next button is hidden.
    init(result: QuestionResult) {
        self.question = result.question
        self.mode = .review
        _questionStage = State(wrappedValue: .showAnswer(result))
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollingContentView { geometry in
                VStack(spacing: questionTextSpacing) {
                    BarkImageView(url: question.imageUrl)
                        .frame(height: geometry.size.height * 0.35)
                        .frame(maxWidth: .infinity)
                    
                    VStack(spacing: questionTextSpacing) {
                        Text(question.questionText)
                            .font(.system(.body, design: .monospaced).bold())
                        
                        VStack(spacing: 48) {
                            AnswerPicker(
                                questionStage: $questionStage,
                                question: question
                            )
                            
                            if showNextButton {
                                LoadingButton(nextButtonText) {
                                    await quizFlowActions.next?()
                                }
                                .buttonStyle(.primary)
                                .transition(.slide)
                                .id(ScrollTarget.nextButton)
                                .accessibilityIdentifier(nextButtonIdentifier)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .scenePadding()
                .animation(
                    .spring(
                        response: 0.45,
                        dampingFraction: 0.75,
                        blendDuration: 0.2
                    ),
                    value: showNextButton
                )
            }
            .onChange(of: questionStage) { oldValue, newValue in
                guard mode == .play, case .showAnswer = questionStage else {
                    return
                }
                
                shouldScrollToNext = true
            }
            .onChange(of: shouldScrollToNext) { _, shouldScroll in
                if shouldScroll {
                    withAnimation(.default, completionCriteria: .logicallyComplete) {
                        proxy.scrollTo(ScrollTarget.nextButton, anchor: .bottom)
                    } completion: {
                        shouldScrollToNext = false
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    exitButton
                }
            }
            .background(backgroundColor)
            .navigationBarBackButtonHidden(mode == .play)
            .navigationTitle(Text(titleText).accessibilityLabel(navBarAxLabel))
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog($confirmationAlert)
        }
    }
    
    private var navBarAxLabel: String {
        switch mode {
        case .review:
            "Question number \(question.location.questionNumber)"
        case .play:
            "Question \(question.location.questionNumber) of \(question.location.totalCount)"
        }
    }
    
    private var exitButton: some View {
        switch mode {
        case .review:
            Button("Close") {
                quizFlowActions.quit?()
            }
        case .play:
            Button("Quit") {
                confirmationAlert = quitConfirmation()
            }
        }
    }
    
    private func quitConfirmation() -> ConfirmationDialogModel {
        let action = ConfirmationDialogModel.Action(
            "Quit now",
            role: .destructive,
            action: {
                quizFlowActions.quit?()
            }
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
