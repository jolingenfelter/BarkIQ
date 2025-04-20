//
//  QuizView+ErrorView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

extension QuizView {
    struct ErrorView: View {
        @ScaledMetric(relativeTo: .largeTitle)
        private var verticalSpacing: CGFloat = 12
        
        let error: String
        let retryAction: () async -> Void
        
        var body: some View {
            ScrollingContentView { geometry in
                VStack(spacing: verticalSpacing) {
                    Text(error)
                    RetryButton(retryAction: retryAction)
                }
                .frame(
                    maxWidth: .infinity,
                    minHeight: geometry.size.height
                )
                .scenePadding()
            }
        }
    }
}

#Preview {
    QuizView.ErrorView(
        error: "An unknown error occured",
        retryAction: {
            try? await Task.sleep(for: .seconds(2))
        }
    )
}
