//
//  RetryButton.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct RetryButton: View {
    let retryAction: () async -> Void
    
    var body: some View {
        LoadingButton(action: retryAction) {
            HStack {
                Image(systemName: "arrow.clockwise")
                    .accessibilityHidden(true)
                Text("Retry")
            }
            .accessibilityElement(children: .combine)
        }
    }
}

#Preview {
    RetryButton {
        try? await Task.sleep(for: .seconds(2))
    }
}
