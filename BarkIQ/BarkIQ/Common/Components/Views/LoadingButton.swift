//
//  LoadingButton.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct LoadingButton<Label: View>: View {
    let action: () async -> Void
    let label: () -> Label
    
    @State private var isLoading = false
    
    init(
        action: @escaping () async -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button {
            isLoading = true
            
            Task {
                await action()
                isLoading = false
            }
            
        } label: {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                label()
            }
        }
        .disabled(isLoading)
        .animation(.default, value: isLoading)
    }
}

extension LoadingButton where Label == Text {
    init(_ title: String, action: @escaping () async -> Void) {
        self.action = action
        self.label = { Text(title) }
    }
}

private struct LoadingButtonPreview: View {
    var body: some View {
        VStack {
            LoadingButton("Primary Button") {
                try? await Task.sleep(for: .seconds(2))
            }
            .buttonStyle(.primary)
            
            LoadingButton("Secondary Button") {
                try? await Task.sleep(for: .seconds(2))
            }
            .buttonStyle(.secondary)
        }
        .scenePadding()
    }
}

#Preview {
    LoadingButtonPreview()
}
