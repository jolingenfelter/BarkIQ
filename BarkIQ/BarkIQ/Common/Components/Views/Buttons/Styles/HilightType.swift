//
//  HilightType.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/20/25.
//

import SwiftUI

enum HilightType: Equatable {
    case positive
    case negative
    
    var color: Color {
        switch self {
        case .positive:
            return .green
        case .negative:
            return .red
        }
    }
}

enum HighlightBehavior: Equatable {
    case none
    case hilightable(HilightType)
}
