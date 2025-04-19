//
//  QuizView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct QuizView: View {
    @ScaledMetric
    private var questionTextSpacing: CGFloat = 24
    
    @State
    private var decodedImage: Image?
    
    @State
    private var quizController: QuizController
    
    let showResults: () -> Void
    let quitAction: () -> Void
    
    init(
        settings: QuizSettings,
        showResults: @escaping () -> Void,
        quitAction: @escaping () -> Void
    ) {
        _quizController = State(wrappedValue: QuizController(settings: settings))
        self.showResults = showResults
        self.quitAction = quitAction
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
                    
                    Text(quizController.currentQuestion.questionText)
                        .font(.system(.body, design: .monospaced).bold())
                    
                    VStack(spacing: 16) {
                        ForEach(quizController.currentQuestion.choices, id: \.self) { breed in
                            Button(breed.displayName) {
                    
                            }
                            .buttonStyle(.secondary)
                            
                        }
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Quit") {
                            quitAction()
                        }
                    }
                }
                .onAppear {
                    setupQuestion()
                }
                .scenePadding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarBackButtonHidden()
                .interactiveDismissDisabled()
                .navigationTitle("1/5")
            }
        }
        .background(Color.barkBackground)
    }
    
    private func setupQuestion() {
        decodedImage = Image(data: quizController.currentQuestion.imageData)
    }
}

#Preview {
    QuizView(
        settings: .mock,
        showResults: {},
        quitAction: {}
    )
}
