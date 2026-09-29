//
//  ToastSurface.swift
//  ToastUI
//

import SwiftUI

/// How a toast or overlay panel is filled in. One place for the three looks that
/// used to be three near-identical view bodies.
public enum ToastSurface: Sendable, Equatable {
    /// Solid brand colour with a gradient, white text on top.
    case solid(Color)
    /// Liquid Glass on iOS 26 / macOS 26, a material everywhere else.
    case glass
    /// No background at all.
    case clear

    /// Text and icons drawn on this surface.
    var foreground: Color {
        switch self {
        case .solid: .white
        case .glass, .clear: .primary
        }
    }

    var secondaryForeground: Color {
        switch self {
        case .solid: .white.opacity(0.9)
        case .glass, .clear: .secondary
        }
    }
}

extension View {
    /// Applies a `ToastSurface` behind the view.
    @ViewBuilder
    func toastSurface(_ surface: ToastSurface,
                      cornerRadius: CGFloat,
                      shadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        switch surface {
        case .solid(let color):
            self.background(shape.fill(color.gradient)
                .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y))
        case .glass:
            if #available(iOS 26.0, macOS 26.0, *) {
                // The real thing, not a material standing in for it.
                self.glassEffect(.regular, in: shape)
                    .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
            } else {
                self.background(shape.fill(.regularMaterial)
                    .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y))
                    .overlay(shape.stroke(Color.white.opacity(0.12), lineWidth: 1))
            }
        case .clear:
            self
        }
    }
}
