//
//  QuestionView+ChoiceButton.swift.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/21/25.
//

import SwiftUI

extension QuestionView {
    struct ChoiceButton: View {
        let choice: Breed
        let question: Question
        let questionStage: QuestionStage
        let action: () -> Void
        
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
        
        var body: some View {
            Button(choice.displayName, action: action)
                .buttonStyle(.quiz(highlight))
                .disabled(questionStage != .ask)
        }
    }
}

#Preview {
    QuestionView
        .ChoiceButton(
            choice: .mock1,
            question: .mock(),
            questionStage: .showAnswer(QuestionResult(question: .mock(), selectedAnswer: .mock3)),
            action: {}
        )
}
