//
//  QuizFlow.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

/// The root view of the modal flow that contains a quiz.  This view
/// owns the `QuizController`, which maintains the state
/// of the quiz and directs progress through the entire flow.
struct QuizFlow: View {
    
    /// Represents the stage of the quiz, which
    /// determines the kind of view to show
    private enum Stage: Hashable, Equatable {
        /// The quiz is in progress and showing a
        /// question in either the answered or
        /// unanswered state
        case quiz(Question)
        
        /// The quiz has been completed and results
        /// are being shown
        case results([QuestionResult])
        
        /// An error has occured either in fetching
        /// data or in data manipulation
        case error(String)
    }
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State
    private var navigationPath: [Stage] = []
    
    @State
    private var quizController: QuizController
    
    // Disable swipe down during the quiz, where
    // a confirmation dialog is shown to confirm
    // before quitting.
    private var disablesSwipeDown: Bool {
        if let top = navigationPath.last {
            if case .quiz = top {
                return true
            }
        }
       
        return false
    }
    
    // Used to check whether or not a a dismiss
    // button should be in the nav bar.  In
    // cases where the retry button has been
    // pressed, and a subsequent error is
    // returned.  This property is read to
    // prevent pushing another error view onto
    // the stack.
    private var isCurrentlyError: Bool {
        if let top = navigationPath.last {
            if case .error = top {
                return true
            }
        }
       
        return false
    }
    
    // Api client can't be fetched from the
    // environment because it wouldn't be
    // avaialable on initialization to pass
    // into the `QuizController`
    init(apiClient: DogApiClient) {
        _quizController = State(wrappedValue: QuizController(apiClient: apiClient))
    }
    
    // Passed into the environment
    // to allow subviews to handle actions
    // from the quiz controller without
    // having direct access to it
    private var quizFlowActions: QuizFlowActions {
        QuizFlowActions(
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
                        guard !isCurrentlyError else {
                            return
                        }
                        
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
                        QuizFlowErrorView(error: error)
                            .navigationBarBackButtonHidden()
                    }
                }
                .interactiveDismissDisabled(disablesSwipeDown)
        }
        .environment(\.quizFlowActions, quizFlowActions)
    }
}

#Preview {
    QuizFlow(apiClient: .mock)
}
