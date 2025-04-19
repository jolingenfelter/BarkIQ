//
//  BarkIQButtonStyle.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct BarkIQButtonStyle: ButtonStyle {
    let color: Color
    
    @ScaledMetric(relativeTo: .largeTitle)
    private var verticalPadding: CGFloat = 16
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    private var foregroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body).bold())
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .foregroundColor(foregroundColor)
            .background(configuration.isPressed ? color.opacity(0.8) : color, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            
    }
}

extension ButtonStyle where Self == BarkIQButtonStyle {
    static var primary: Self { .init(color: .barkPrimary) }
    
    static var secondary: Self { .init(color: .barkSecondary) }
}

#Preview {
    VStack {
        Button("Primary Button!") {}
            .buttonStyle(.primary)
            .scenePadding()
        
        Button("Secondary Button!") {}
            .buttonStyle(.secondary)
            .scenePadding()
    }
}
