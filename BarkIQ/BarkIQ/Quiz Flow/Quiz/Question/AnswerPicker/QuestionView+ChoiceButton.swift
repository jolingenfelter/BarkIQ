//
//  QuestionView+ChoiceButton.swift.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import SwiftUI

extension QuestionView {
    struct ChoiceButton: View {
        @Environment(\.quizFlowActions.recordAnswer)
        private var recordAnswer
        
        let choice: Breed
        let question: Question
        
        @Binding var questionStage: QuestionStage
        
        private var highlight: HighlightBehavior {
            if case .showAnswer(let result) = questionStage {
                if choice == question.answer {
                    return .hilightable(.positive)
                } else if choice == result.selectedAnswer {
                    return .hilightable(.negative)
                }
            }
            return .none
        }
        
        var accessibilityLabel: String {
            if questionStage == .ask {
                return choice.displayName
            } else if case .showAnswer(let result) = questionStage {
                if choice == question.answer {
                    return "\(choice.displayName), correct answer"
                } else if choice == result.selectedAnswer {
                    return "\(choice.displayName), your answer, incorrect"
                }
            }
            return choice.displayName
        }
        
        var body: some View {
            Button(choice.displayName) {
                if let result = recordAnswer?(question, choice) {
                    questionStage = .showAnswer(result)
                }
            }
            .buttonStyle(.quiz(highlight))
            .disabled(questionStage != .ask)
            .accessibilityLabel(accessibilityLabel)
        }
    }
}

private struct ChoiceButtonPreview: View {
    @State var questionStage: QuestionView.QuestionStage = .ask
    
    let question = Question.mock()

    var body: some View {
        NavigationStack {
            // Pass in .mock1 to see it highlight
            // for the right answer and .mock2
            // for the wrong answer
            QuestionView
                .ChoiceButton(
                    choice: .mock2,
                    question: .mock(),
                    questionStage: $questionStage
                )
                .scenePadding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Reset") {
                            questionStage = .ask
                        }
                    }
                }
            
        }
        .environment(\.quizFlowActions, .mock)
    }
}

#Preview {
    ChoiceButtonPreview()
}
