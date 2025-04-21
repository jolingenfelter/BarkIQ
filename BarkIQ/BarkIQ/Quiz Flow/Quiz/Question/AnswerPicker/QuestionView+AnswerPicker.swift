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
                ForEach(question.choices) { choice in
                    ChoiceButton(
                        choice: choice,
                        question: question,
                        questionStage: questionStage,
                        action: {
                            guard let result = quizFlowActions.recordAnswer(question, choice) else { return }
                            questionStage = .showAnswer(result)
                        }
                    )
                }
            }
        }
    }
}


#Preview {
    QuestionView.AnswerPicker(
        questionStage: .constant(.showAnswer(QuestionResult(question: .mock(), selectedAnswer: .mock3))),
        question: .mock()
    )
}
