//
//  ConfidenceIndicator.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

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
