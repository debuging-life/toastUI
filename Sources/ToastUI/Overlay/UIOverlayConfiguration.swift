//
//  UIOverlayConfiguration.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 24/12/25.
//

import SwiftUI

/// Glass effect intensity level
public enum GlassIntensity: Sendable {
    /// Ultra-thin material (lightest blur)
    case ultraThin
    /// Thin material (light blur)
    case thin
    /// Regular material (medium blur)
    case regular
    /// Thick material (heavy blur)
    case thick
    /// Ultra-thick material (heaviest blur)
    case ultraThick

    /// Convert to SwiftUI Material
    @available(iOS 15.0, macOS 12.0, *)
    public var material: Material {
        switch self {
        case .ultraThin:
            return .ultraThinMaterial
        case .thin:
            return .thinMaterial
        case .regular:
            return .regularMaterial
        case .thick:
            return .thickMaterial
        case .ultraThick:
            return .ultraThickMaterial
        }
    }
}

/// Style options for overlay background
public enum OverlayStyle: Sendable {
    /// Glass effect with configurable intensity
    case glass(
        intensity: GlassIntensity = .ultraThin,
        backdropOpacity: Double = 0.3,
        cornerRadius: CGFloat = 20,
        maxWidth: CGFloat = 340
    )

    /// Solid color background
    case solid(
        backgroundColor: Color,
        opacity: Double = 1.0,
        backdropOpacity: Double = 0.3,
        cornerRadius: CGFloat = 20,
        maxWidth: CGFloat = 340
    )
}

/// Text style configuration for overlay text
public struct TextStyleConfiguration: Sendable {
    /// Text color
    public let color: Color

    /// Font style
    public let font: Font

    /// Font weight
    public let fontWeight: Font.Weight

    public init(
        color: Color = .primary,
        font: Font = .headline,
        fontWeight: Font.Weight = .semibold
    ) {
        self.color = color
        self.font = font
        self.fontWeight = fontWeight
    }

    // MARK: - Presets

    /// Default title style (primary color, headline font, semibold weight)
    public static let title = TextStyleConfiguration(
        color: .primary,
        font: .headline,
        fontWeight: .semibold
    )

    /// Default message style (secondary color, subheadline font, regular weight)
    public static let message = TextStyleConfiguration(
        color: .secondary,
        font: .subheadline,
        fontWeight: .regular
    )

    /// Large bold title
    public static let largeBoldTitle = TextStyleConfiguration(
        color: .primary,
        font: .title2,
        fontWeight: .bold
    )

    /// Small light message
    public static let smallLightMessage = TextStyleConfiguration(
        color: .secondary,
        font: .caption,
        fontWeight: .light
    )
}

/// Configuration for UI overlay appearance and behavior
public struct UIOverlayConfiguration: Sendable {
    /// Background style (glass or solid)
    public let style: OverlayStyle

    /// Whether to show close button for dismissible states
    public let showCloseButton: Bool

    /// Auto-dismiss duration in seconds (nil = no auto-dismiss)
    public let autoDismissAfter: TimeInterval?

    /// Title text style configuration
    public let titleStyle: TextStyleConfiguration

    /// Message text style configuration
    public let messageStyle: TextStyleConfiguration

    public init(
        style: OverlayStyle = .solid(backgroundColor: .white),
        titleStyle: TextStyleConfiguration = .title,
        messageStyle: TextStyleConfiguration = .message,
        showCloseButton: Bool = false,
        autoDismissAfter: TimeInterval? = nil
    ) {
        self.style = style
        self.showCloseButton = showCloseButton
        self.autoDismissAfter = autoDismissAfter
        self.titleStyle = titleStyle
        self.messageStyle = messageStyle
    }

    // MARK: - Computed Properties

    /// Get glass intensity from glass style
    public var glassIntensity: GlassIntensity? {
        switch style {
        case .glass(let intensity, _, _, _):
            return intensity
        case .solid:
            return nil
        }
    }

    /// Get backdrop opacity from style
    public var backdropOpacity: Double {
        switch style {
        case .glass(_, let backdropOpacity, _, _):
            return backdropOpacity
        case .solid(_, _, let backdropOpacity, _, _):
            return backdropOpacity
        }
    }

    /// Get corner radius from style
    public var cornerRadius: CGFloat {
        switch style {
        case .glass(_, _, let cornerRadius, _):
            return cornerRadius
        case .solid(_, _, _, let cornerRadius, _):
            return cornerRadius
        }
    }

    /// Get max width from style
    public var maxWidth: CGFloat {
        switch style {
        case .glass(_, _, _, let maxWidth):
            return maxWidth
        case .solid(_, _, _, _, let maxWidth):
            return maxWidth
        }
    }

    /// Get background color from solid style
    public var backgroundColor: Color? {
        switch style {
        case .glass:
            return nil
        case .solid(let backgroundColor, _, _, _, _):
            return backgroundColor
        }
    }

    /// Get overlay opacity from solid style
    public var overlayOpacity: Double? {
        switch style {
        case .glass:
            return nil
        case .solid(_, let opacity, _, _, _):
            return opacity
        }
    }

    // MARK: - Presets

    /// Default configuration with white background
    public static let `default` = UIOverlayConfiguration()

    /// White background with close button
    public static let withClose = UIOverlayConfiguration(showCloseButton: true)

    /// White background with auto-dismiss after 2 seconds
    public static let autoDismiss = UIOverlayConfiguration(autoDismissAfter: 2.0)

    /// Glass effect overlay with ultra-thin material
    public static let glass = UIOverlayConfiguration(style: .glass())

    /// Glass effect with thin material
    public static let glassThin = UIOverlayConfiguration(style: .glass(intensity: .thin))

    /// Glass effect with regular material
    public static let glassRegular = UIOverlayConfiguration(style: .glass(intensity: .regular))

    /// Glass effect with thick material
    public static let glassThick = UIOverlayConfiguration(style: .glass(intensity: .thick))

    /// Glass effect with ultra-thick material
    public static let glassUltraThick = UIOverlayConfiguration(style: .glass(intensity: .ultraThick))

    /// Glass effect with close button
    public static let glassWithClose = UIOverlayConfiguration(
        style: .glass(),
        showCloseButton: true
    )

    /// Solid black overlay
    public static let solidBlack = UIOverlayConfiguration(
        style: .solid(backgroundColor: .black, opacity: 0.95)
    )

    /// Custom solid color
    public static func solid(backgroundColor: Color, opacity: Double = 1.0) -> UIOverlayConfiguration {
        UIOverlayConfiguration(style: .solid(backgroundColor: backgroundColor, opacity: opacity))
    }

    /// Custom glass effect with specific intensity
    public static func glass(intensity: GlassIntensity, backdropOpacity: Double = 0.3) -> UIOverlayConfiguration {
        UIOverlayConfiguration(style: .glass(intensity: intensity, backdropOpacity: backdropOpacity))
    }
}
