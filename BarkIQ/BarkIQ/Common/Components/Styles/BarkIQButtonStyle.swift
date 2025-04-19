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
    
    @Environment(\.isEnabled)
    private var isEnabled
    
    private var foregroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    private var backgroundColor: Color {
        isEnabled ? color : Color(white: 0.85)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body).bold())
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .foregroundColor(isEnabled ? foregroundColor : .gray)
            .background {
                backgroundColor
                    .saturation(configuration.isPressed && isEnabled ? 0.85 : 1.0)
                    .brightness(configuration.isPressed && isEnabled ? -0.05 : 0)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
    }
}

extension ButtonStyle where Self == BarkIQButtonStyle {
    static var primary: Self { .init(color: .barkPrimary) }
    
    static var secondary: Self { .init(color: .barkSecondary) }
}

#Preview {
    VStack {
        Button("Primary Button") {}
            .buttonStyle(.primary)
            .scenePadding()
        
        Button("Disabled Button") {}
            .buttonStyle(.primary)
            .scenePadding()
            .disabled(true)
        
        Button("Secondary Button") {}
            .buttonStyle(.secondary)
            .scenePadding()
    }
}
