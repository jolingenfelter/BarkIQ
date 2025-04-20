//
//  ConfidenceLevel.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

enum ConfidenceLevel: String, Identifiable, CaseIterable {
    case high
    case medium
    case low

    init(bool: Bool) {
        self = bool ? .high : .low
    }

    var id: String {
        rawValue
    }

    var colorValue: Color {
        switch self {
        case .high:
            return .green
        case .medium:
            return .yellow
        case .low:
            return .red
        }
    }
}
