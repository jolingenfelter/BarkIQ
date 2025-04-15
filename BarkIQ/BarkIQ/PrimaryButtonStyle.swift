//
//  PrimaryButtonStyle.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let cornerRadius: CGFloat = 12
    
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
            .background(configuration.isPressed ? Color.barkPrimary.opacity(0.8) : Color.barkPrimary, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: Self { .init() }
}

#Preview {
    Button("Press me!") {}
        .buttonStyle(.primary)
        .scenePadding()
}
