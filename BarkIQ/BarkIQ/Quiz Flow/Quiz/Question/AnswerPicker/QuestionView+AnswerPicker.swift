//
//  QuestionView+AnswerPicker..swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

extension QuestionView {
    /// Visually displays the answer choices as a vertical list of buttons.
    ///
    /// Once an answer is selected, the correct one is highlighted in green,
    /// the selected wrong answer (if any) is shown in red, and the rest stay neutral.
    /// All buttons are disabled after an answer is picked.
    struct AnswerPicker: View {
        @Environment(\.quizFlowActions)
        private var quizFlowActions
        
        @Binding
        var questionStage: QuestionStage
        
        let question: Question
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(question.choices.enumerated()), id: \.element) { index, choice in
                    ChoiceButton(
                        choice: choice,
                        question: question,
                        questionStage: $questionStage
                    )
                    .accessibilityIdentifier("quiz-choice-button-\(index)")
                }
            }
        }
    }
}

private struct AnswerPickerPreview: View {
    @State var questionStage: QuestionView.QuestionStage = .ask
    
    let question = Question.mock()
    
    var quizFlowActions: QuizFlowActions {
        QuizFlowActions(
            next: {},
            recordAnswer: { question, breed in
                return QuestionResult(
                    question: question,
                    selectedAnswer: breed
                )
            },
            quit: {},
            restart: {}
        )
    }
    
    var body: some View {
        NavigationStack {
            QuestionView.AnswerPicker(
                questionStage: $questionStage,
                question: question
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
        .environment(\.quizFlowActions, quizFlowActions)
        
    }
}

#Preview {
    AnswerPickerPreview()
}
