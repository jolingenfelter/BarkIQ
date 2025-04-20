//
//  QuizFlow.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct QuizFlow: View {
    private enum Stage: Hashable {
        case quiz(Question)
        case results([QuestionResult])
        case error(String)
    }
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var navigationPath: [Stage] = []
    
    @State
    private var quizController: QuizController
    
    init(apiClient: DogApiClient) {
        _quizController = State(wrappedValue: QuizController(apiClient: apiClient))
    }
    
    private var quizActions: QuizActions {
        QuizActions(
            next: quizController.next,
            recordAnswer: { question, selected in
                quizController.checkAnswer(
                    for: question,
                    selected: selected
                )
            },
            quit: {
                dismiss()
            },
            restart: {
                navigationPath.removeAll()
                quizController.reset()
            }
        )
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            QuizSetupView(settings: $quizController.settings)
                .onChange(of: quizController.currentState) { oldValue, newValue in
                    switch newValue {
                    case .error(let error):
                        navigationPath.append(.error(error))
                    case .question(let question):
                        navigationPath.append(.quiz(question))
                    case .results(let results):
                        navigationPath.append(.results(results))
                    default:
                        break
                    }
                }
                .navigationDestination(for: Stage.self) { stage in
                    switch stage {
                    case .quiz(let question):
                        QuestionView(question: question)
                    case .results(let results):
                        ResultsView(results: results)
                    case .error(let error):
                        QuizFlowErrorView(
                            error: error,
                            retryAction: quizController.next
                        )
                    }
                }
        }
        .environment(\.quizActions, quizActions)
    }
}

#Preview {
    QuizFlow(apiClient: .mock)
}
