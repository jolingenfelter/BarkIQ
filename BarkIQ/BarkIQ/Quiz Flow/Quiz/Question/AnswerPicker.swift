//
//  AnswerPicker.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

extension QuestionView {
    struct AnswerPicker: View {
        @Environment(\.quizActions)
        private var quizActions
        
        @Binding
        var questionStage: QuestionStage
        
        let question: Question
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(question.choices) { choice in
                    choiceButton(choice)
                }
            }
        }
        
        @ViewBuilder
        private func choiceButton(_ choice: Breed) -> some View {
            let isCorrect = choice == question.answer
            var highlight: HighlightBehavior {
                guard case .showAnswer(let result) = questionStage else {
                    return .none
                }
                
                if isCorrect {
                    return .hilightable(.positive)
                } else if choice == result.selectedAnswer {
                    return .hilightable(.negative)
                } else {
                    return .none
                }
            }
            
            Button(choice.displayName) {
                guard let result = quizActions.recordAnswer(question, choice) else {
                    return
                }
                
                questionStage = .showAnswer(result)
            }
            .buttonStyle(.quiz(highlight))
            .disabled(questionStage != .ask)
        }
    }
}

private struct AnswerPickerPreviewWrapper: View {
    @State private var stage: QuestionView.QuestionStage = .ask
    
    var body: some View {
        VStack(spacing: 48) {
            QuestionView
                .AnswerPicker(
                    questionStage: $stage,
                    question: .mock()
                )
            
            if case .showAnswer = stage {
                Button("Reset") {
                    stage = .ask
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
    }
}

#Preview {
    AnswerPickerPreviewWrapper()
}
