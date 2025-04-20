//
//  EnvironmentValues+QuizActions.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

private struct QuizActionsKey: EnvironmentKey {
    static let defaultValue = QuizActions(
        next: {},
        recordAnswer: { _, _ in
            return nil
        },
        quit: {}
    )
}

extension EnvironmentValues {
    var quizActions: QuizActions {
        get { self[QuizActionsKey.self] }
        set { self[QuizActionsKey.self] = newValue }
    }
}
