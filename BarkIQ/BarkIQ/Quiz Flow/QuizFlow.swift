//
//  QuizFlow.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct QuizFlow: View {
    private enum Stage: Hashable {
        case quiz(QuizSettings)
        case results
    }
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var navigationPath: [Stage] = []

    var body: some View {
        NavigationStack(path: $navigationPath) {
            QuizSetupView(
                startQuizAction: { settings in
                    navigationPath.append(.quiz(settings))
                },
                dismissAction: {
                    dismiss()
                }
            )
            .navigationDestination(for: Stage.self) { stage in
                switch stage {
                case .quiz(let settings):
                    QuizView(
                        settings: settings,
                        showResults: {
                            navigationPath.append(.results)
                        },
                        quitAction: {
                            dismiss()
                        }
                    )
                case .results:
                    ResultsView()
                }
            }
        }
    }
}

#Preview {
    QuizFlow()
        .environment(\.dogApiClient, .mock)
}
