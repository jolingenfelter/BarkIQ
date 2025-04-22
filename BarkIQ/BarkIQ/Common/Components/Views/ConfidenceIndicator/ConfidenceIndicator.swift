//
//  ConfidenceIndicator.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

/// A small circular visual indicator that represents a `ConfidenceLevel`.
/// Used to quickly show how well the user knows a particular breed based on quiz history.
/// The color reflects the confidence: typically green for high, yellow for medium, red for low.
///
/// Can be initialized directly with a `ConfidenceLevel`, or with a `Bool`
/// (where `true` = high confidence, `false` = low) to indicate a binary for
/// "correct" vs. "incorrect", allowing this view to be used to be used in the context
/// of giving quiz question results.
struct ConfidenceIndicator: View {
    let level: ConfidenceLevel
    
    init(level: ConfidenceLevel) {
        self.level = level
    }
    
    init(bool: Bool) {
        self.level = ConfidenceLevel(bool: bool)
    }

    var body: some View {
        Circle()
            .foregroundStyle(level.colorValue)
            .frame(width: 10, height: 10)
            .accessibilityElement()
    }
}

#Preview {
    VStack {
        ConfidenceIndicator(level: .high)
        ConfidenceIndicator(level: .medium)
        ConfidenceIndicator(level: .low)
    }
}
