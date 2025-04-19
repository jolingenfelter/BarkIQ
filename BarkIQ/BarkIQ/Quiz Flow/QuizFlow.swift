//
//  QuizFlow.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/19/25.
//

import SwiftUI

struct QuizFlow: View {
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        NavigationStack {
            QuizSettingsView {
                dismiss()
            }
        }
    }
}

#Preview {
    QuizFlow()
}
