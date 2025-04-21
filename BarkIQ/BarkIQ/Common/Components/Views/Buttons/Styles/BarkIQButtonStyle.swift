//
//  BarkIQButtonStyle.swift
//  BarkIQ
//
//  Created by Jo Lingenfelter on 4/14/25.
//

import SwiftUI

struct BarkIQButtonStyle: ButtonStyle {
    let color: Color
    let highlight: HighlightBehavior
    
    @ScaledMetric(relativeTo: .largeTitle)
    private var verticalPadding: CGFloat = 16
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body).bold())
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .foregroundColor(resolveForegroundColor())
            .background(resolveBackground(configuration: configuration))
    }
    
    // MARK: - Colors
    
    private func resolveForegroundColor() -> Color {
        if !isEnabled {
            return .barkDisabledForeground
        }
        
        switch highlight {
        case .hilightable:
            return .barkText
        case .none:
            return colorScheme == .dark ? .black : .white
        }
    }
    
    @ViewBuilder
    private func resolveBackground(configuration: Configuration) -> some View {
        let noHighlight = highlight == .none
        let shouldApplyEffect = noHighlight && isEnabled && configuration.isPressed
        backgroundFill
            .modifier(PressedEffect(applyEffect: shouldApplyEffect))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var backgroundFill: Color {
        switch highlight {
        case .none:
            return isEnabled ? color : .barkDisabledBackground
        case .hilightable(let type):
            switch type {
            case .positive:
                return Color.green.opacity(0.4)
            case .negative:
                return Color.red.opacity(0.4)
            }
        }
    }
}

// MARK: - Pressed Animation Modifier

private struct PressedEffect: ViewModifier {
    let applyEffect: Bool
    
    func body(content: Content) -> some View {
        content
            .saturation(applyEffect ? 0.85 : 1.0)
            .brightness(applyEffect ? -0.05 : 0)
    }
}

extension ButtonStyle where Self == BarkIQButtonStyle {
    
    /// Uses the app's primary color and standard foreground styling.
    /// This style does not support highlighting states.
    static var primary: Self {
        BarkIQButtonStyle(
            color: .barkPrimary,
            highlight: .none
        )
    }
    
    /// Uses the app's secondary color and standard styling.
    /// This style does not support highlighting states.
    static var secondary: Self {
        BarkIQButtonStyle(
            color: .barkSecondary,
            highlight: .none
        )
    }
    
    /// A flexible button style designed for quiz answer choices.
    ///
    /// Accepts an optional `HighlightBehavior` to visually indicate correctness
    /// (e.g., green for correct, red for incorrect). Falls back to a standard secondary style.
    ///
    /// - Parameter highlight: A behavior that controls visual feedback when showing an answer.
    ///   Use `.none` to disable feedback, or `.hilightable(.positive)` / `.hilightable(.negative)`
    ///   for correct/incorrect styling. The intention is for the button to be disabled when
    ///   hilight != .none.
    static func quiz(_ highlight: HighlightBehavior = .none) -> Self {
        BarkIQButtonStyle(
            color: .barkSecondary,
            highlight: highlight
        )
    }
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
        
        Button("Positive Hilight Button") {}
            .buttonStyle(.quiz(.hilightable(.positive)))
            .scenePadding()
        
        Button("Negative Hilight Button") {}
            .buttonStyle(.quiz(.hilightable(.negative)))
            .scenePadding()
    }
}
