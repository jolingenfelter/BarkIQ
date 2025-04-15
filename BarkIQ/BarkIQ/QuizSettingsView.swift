//
//  QuizSettingsView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct QuizSettingsView: View {
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
                        
                    }
                    .buttonStyle(.primary)
                    .padding(.top, 28)
                }
                
            }
            .navigationTitle(Text("Quiz Settings"))
        }
    }
}

#Preview {
    QuizSettingsView()
}
