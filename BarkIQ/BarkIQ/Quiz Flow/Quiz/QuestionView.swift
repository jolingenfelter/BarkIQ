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
            return (isCorrect ? Color.green : Color.red).opacity(0.25)
        default:
            return .barkBackground
        }
    }
    
    let question: Question?
    let answerAction: (Breed) -> Bool
    let nextAction: () async -> Void
    
    var body: some View {
        ScrollingContentView { geometry in
            VStack(spacing: questionTextSpacing) {
                BarkImageView(url: question?.imageUrl)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: geometry.size.height * 0.35,
                        maxHeight: geometry.size.height * 0.4
                    )
                
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
                    
                    if isShowingAnswer {
                        Button("Next") {
                            questionStage = .ask
                            
                            Task {
                                await nextAction()
                            }
                        }
                        .buttonStyle(.primary)
                    }
                }
            }
            .scenePadding()
            .animation(.default, value: isShowingAnswer)
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
