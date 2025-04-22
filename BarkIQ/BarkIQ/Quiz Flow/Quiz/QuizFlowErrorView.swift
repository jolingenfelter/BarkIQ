//
//  QuizFlowErrorView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

/// Used as a full-screen error in the quiz flow when the app
/// experiences an error (such as a failed API call or loss of internet
/// connection).  This view has a retry button that calls the `next`
/// method in the `QuizFlowActions`, which it pulls from the
/// environment.
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
                
                if let retryAction = quizFlowActions.next {
                    RetryButton(retryAction: retryAction)
                }
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
                    quizFlowActions.quit?()
                }
            }
        }
    }
}

#Preview {
    QuizFlowErrorView(error: "An unknown error occured")
        .environment(\.quizFlowActions, .mock)
    
}
