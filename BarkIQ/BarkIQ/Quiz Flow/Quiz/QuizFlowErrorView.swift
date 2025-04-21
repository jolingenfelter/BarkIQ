//
//  QuizFlowErrorView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct QuizFlowErrorView: View {
    @Environment(\.quizFlowActions)
    private var quizFlowActions
    
    @ScaledMetric(relativeTo: .largeTitle)
    private var verticalSpacing: CGFloat = 12
    
    let error: String
    
    var body: some View {
        ScrollingContentView { geometry in
            VStack(spacing: verticalSpacing) {
                Text(error)
                RetryButton(retryAction: quizFlowActions.next)
            }
            .frame(
                maxWidth: .infinity,
                minHeight: geometry.size.height
            )
            .scenePadding()
            .accessibilityElement(children: .combine)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Close") {
                    quizFlowActions.quit()
                }
            }
        }
    }
}

#Preview {
    QuizFlowErrorView(error: "An unknown error occured")
        .environment(\.quizFlowActions, QuizFlowActions(next: {
            try? await Task.sleep(for: .seconds(2))
        }, recordAnswer: {_, _ in return .mock1 }, quit: {}, restart: {}))
    
}
