//
//  QuizQuestionView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct QuizQuestionView: View {
    
    @ScaledMetric
    private var questionTextSpacing: CGFloat = 24
    
    @State
    private var decodedImage: Image?
    
    let question: Question
    
    let handleQuitAction: () -> Void
    
    init(question: Question, handleQuitAction: @escaping () -> Void) {
        self.question = question
        self.handleQuitAction = handleQuitAction
        _decodedImage = State(initialValue: Image(data: question.imageData))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: questionTextSpacing) {
                    if let decodedImage {
                        decodedImage
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: geometry.size.width - geometry.safeAreaInsets.leading - geometry.safeAreaInsets.trailing, maxHeight: geometry.size.height * 0.4)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    }
                    
                    Text(question.questionText)
                        .font(.system(.body, design: .monospaced).bold())
                    
                    VStack(spacing: 16) {
                        ForEach(question.choices, id: \.self) { breed in
                            Button(breed.displayName) {
                    
                            }
                            .buttonStyle(.secondary)
                            
                        }
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Quit") {
                            handleQuitAction()
                        }
                    }
                }
                .scenePadding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarBackButtonHidden()
                .interactiveDismissDisabled(true)
                .navigationTitle("1/5")
            }
        }
        .background(Color.barkBackground)
    }
}

#Preview {
    QuizQuestionView(
        question: .mock(),
        handleQuitAction: {}
    )
}
