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
    
    private var isShowingAnswer: Bool {
        guard case .showAnswer = questionStage else {
            return false
        }

        return true
    }
    
    private var backgroundColor: Color {
        switch questionStage {
        case .showAnswer(let isCorrect):
            return (isCorrect ? Color.green : Color.red).opacity(0.15)
        default:
            return .barkBackground
        }
    }
    
    let question: Question?
    let answerAction: (Breed) -> Bool
    let nextAction: () -> Void
    
    var body: some View {
        ScrollingContentView { geometry in
            VStack(spacing: questionTextSpacing) {
                BarkImageView(url: question?.imageUrl)
                    .frame(height: geometry.size.height * 0.35)
                    .frame(maxWidth: .infinity)
                
                if let question {
                    Text(question.questionText)
                        .font(.system(.body, design: .monospaced).bold())
                }
                
                VStack(spacing: 48) {
                    VStack(spacing: 16) {
                        ForEach(question?.choices ?? []) { breed in
                            Button(breed.displayName) {
                                let isCorrect = answerAction(breed)
                                questionStage = .showAnswer(isCorrect)
                            }
                            .buttonStyle(.secondary)
                            .disabled(isShowingAnswer)
                        }
                    }
                    
                    // Some sort of "continue" action
                    // to handle ending a quiz
                    if isShowingAnswer {
                        Button("Next") {
                            questionStage = .ask
                            nextAction()
                        }
                        .buttonStyle(.primary)
                    }
                }
            }
            .scenePadding()
            .animation(.default, value: isShowingAnswer)
            .animation(.default, value: question)
        }
        .background(backgroundColor)
    }
}

#Preview {
    QuestionView(
        question: .mock(),
        answerAction: { _ in
            return Bool.random()
        },
        nextAction: {})
}
