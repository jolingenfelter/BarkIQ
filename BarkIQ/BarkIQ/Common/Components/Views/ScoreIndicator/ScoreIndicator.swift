//
//  ScoreIndicator.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

struct ScoreIndicator: View {
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
            .padding(.vertical)
    }
}

#Preview {
    VStack {
        ScoreIndicator(level: .high)
        ScoreIndicator(level: .medium)
        ScoreIndicator(level: .low)
    }
}
