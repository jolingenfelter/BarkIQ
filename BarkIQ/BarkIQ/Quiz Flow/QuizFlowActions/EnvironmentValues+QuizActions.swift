//
//  EnvironmentValues+quizFlowActions.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var quizFlowActions: QuizFlowActions = QuizFlowActions(
        next: {},
        recordAnswer: { _, _ in
            return nil
        },
        quit: {},
        restart: {}
    )
}
