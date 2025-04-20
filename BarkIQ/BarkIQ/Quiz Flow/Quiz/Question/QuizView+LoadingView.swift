//
//  QuizView+LoadingView.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

extension QuizView {
    struct LoadingView: View {
        var body: some View {
            ScrollingContentView { geometry in
                ProgressView()
                    .frame(
                        maxWidth: .infinity,
                        minHeight: geometry.size.height
                    )
            }
            .background(Color.barkBackground)
        }
    }
}

#Preview {
    QuizView.LoadingView()
}
