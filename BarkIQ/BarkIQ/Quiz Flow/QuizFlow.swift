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
        case results
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

    var body: some View {
        NavigationStack(path: $navigationPath) {
            QuizSetupView(
                settings: $quizController.settings,
                startQuizAction: {
                    await quizController.next()
                },
                dismissAction: {
                    dismiss()
                }
            )
            .onChange(of: quizController.currentState) { oldValue, newValue in
                switch newValue {
                case .error(let error):
                    navigationPath.append(.error(error))
                case .question(let question):
                    navigationPath.append(.quiz(question))
                case .results:
                    navigationPath.append(.results)
                default:
                    break
                }
            }
            .navigationDestination(for: Stage.self) { stage in
                switch stage {
                case .quiz(let question):
                    QuestionView(
                        question: question,
                        answerAction: { answer in
                            quizController.recordAnswer(for: question, selected: answer)
                        },
                        nextAction: quizController.next,
                        quitAction: {
                            dismiss()
                        }
                    )
                case .results:
                    ResultsView()
                case .error(let error):
                    QuizFlowErrorView(
                        error: error,
                        retryAction: quizController.next
                    )
                }
            }
        }
    }
}

#Preview {
    QuizFlow(apiClient: .mock)
}
