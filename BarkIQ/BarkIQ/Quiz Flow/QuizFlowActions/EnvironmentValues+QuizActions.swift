//
//  EnvironmentValues+QuizActions.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

private struct QuizFlowActionsKey: EnvironmentKey {
    static let defaultValue = QuizFlowActions(
        next: {},
        recordAnswer: { _, _ in
            return nil
        },
        quit: {},
        restart: {}
    )
}

extension EnvironmentValues {
    var quizActions: QuizFlowActions {
        get { self[QuizFlowActionsKey.self] }
        set { self[QuizFlowActionsKey.self] = newValue }
    }
}
