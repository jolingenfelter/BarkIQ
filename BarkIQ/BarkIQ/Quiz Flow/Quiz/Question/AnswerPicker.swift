//
//  AnswerPicker.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

extension QuestionView {
    struct AnswerPicker: View {
        let choices: [Breed]
        let correctAnswer: Breed
        
        @Binding
        var questionStage: QuestionStage
        
        @State
        private var selectedChoice: Breed? = nil

        let selectChoiceAction: (Breed) -> Void
        
        private var isShowingAnswer: Bool {
            guard case .showAnswer = questionStage else {
                return false
            }
            
            return true
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(choices) { choice in
                    choiceButton(choice)
                }
            }
        }

        @ViewBuilder
        private func choiceButton(_ choice: Breed) -> some View {
            var highlight: HighlightBehavior {
                  guard case .showAnswer = questionStage else { return .none }

                  if choice == correctAnswer {
                      return .hilightable(.positive)
                  } else if choice == selectedChoice {
                      return .hilightable(.negative)
                  } else {
                      return .none
                  }
              }

            Button(choice.displayName) {
                let isCorrect = choice == correctAnswer
                selectedChoice = choice
                questionStage = .showAnswer(isCorrect)
            }
            .buttonStyle(.quiz(highlight))
            .disabled(isShowingAnswer)
        }
    }
}

private struct AnswerPickerPreviewWrapper: View {
    @State private var stage: QuestionView.QuestionStage = .ask

    var body: some View {
        VStack(spacing: 48) {
            QuestionView.AnswerPicker(
                choices: Breed.mockArray,
                correctAnswer: .mock1,
                questionStage: $stage,
                selectChoiceAction: { _ in }
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
