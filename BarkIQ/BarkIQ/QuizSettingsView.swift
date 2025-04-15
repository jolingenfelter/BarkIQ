//
//  QuizSettingsView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

// Add QuizFlowView
struct QuizSettingsView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var isShowingQuestion: Bool = false
    @State private var questionCount: Int = 5
    
    private let countOptions = Array(stride(from: 5, through: 25, by: 5))
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Question count", selection: $questionCount) {
                        ForEach(countOptions, id: \.self) { option in
                            Text("\(option)")
                                .tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                } footer: {
                    Button("Start Quiz") {
                        isShowingQuestion = true
                    }
                    .buttonStyle(.primary)
                    .padding(.top, 28)
                }
                
            }
            .navigationTitle(Text("Quiz Settings"))
            .navigationDestination(isPresented: $isShowingQuestion) {
                QuizQuestionView(
                    question: .mock(),
                    handleQuitAction: {
                        dismiss()
                    }
                )
            }
        }
    }
}

#Preview {
    QuizSettingsView()
}
