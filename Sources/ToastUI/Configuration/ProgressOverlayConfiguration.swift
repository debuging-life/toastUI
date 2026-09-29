//
//  ProgressOverlayConfiguration.swift
//  ToastUI
//
//  Created by Pardip Bhatti
//

import SwiftUI

/// Configuration for progress overlay appearance and behavior
public struct ProgressOverlayConfiguration: Sendable, Equatable {
    /// Background color of the overlay
    public let backgroundColor: Color

    /// Background opacity (0.0 to 1.0)
    public let backgroundOpacity: Double

    /// Whether to use glass effect (iOS 26+ only, falls back to regular material)
    public let useGlassEffect: Bool

    /// Whether background should be completely clear
    public let clearBackground: Bool

    /// Corner radius of the overlay
    public let cornerRadius: CGFloat

    /// Width of the overlay (nil for auto)
    public let width: CGFloat?

    /// Height of the overlay (nil for auto)
    public let height: CGFloat?

    /// Minimum width
    public let minWidth: CGFloat

    /// Minimum height
    public let minHeight: CGFloat

    /// Horizontal padding
    public let horizontalPadding: CGFloat

    /// Vertical padding
    public let verticalPadding: CGFloat

    /// Shadow color
    public let shadowColor: Color

    /// Shadow radius
    public let shadowRadius: CGFloat

    /// Shadow X offset
    public let shadowX: CGFloat

    /// Shadow Y offset
    public let shadowY: CGFloat

    /// Whether the overlay blocks user interaction with content below
    public let isBlocking: Bool

    /// Backdrop opacity (when blocking)
    public let backdropOpacity: Double

    public init(
        backgroundColor: Color = .black,
        backgroundOpacity: Double = 0.85,
        useGlassEffect: Bool = false,
        clearBackground: Bool = false,
        cornerRadius: CGFloat = 16,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        minWidth: CGFloat = 120,
        minHeight: CGFloat = 120,
        horizontalPadding: CGFloat = 24,
        verticalPadding: CGFloat = 24,
        shadowColor: Color = .black.opacity(0.2),
        shadowRadius: CGFloat = 8,
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 4,
        isBlocking: Bool = true,
        backdropOpacity: Double = 0.3
    ) {
        self.backgroundColor = backgroundColor
        self.backgroundOpacity = backgroundOpacity
        self.useGlassEffect = useGlassEffect
        self.clearBackground = clearBackground
        self.cornerRadius = cornerRadius
        self.width = width
        self.height = height
        self.minWidth = minWidth
        self.minHeight = minHeight
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.isBlocking = isBlocking
        self.backdropOpacity = backdropOpacity
    }

    public static func == (lhs: ProgressOverlayConfiguration, rhs: ProgressOverlayConfiguration) -> Bool {
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.backgroundOpacity == rhs.backgroundOpacity &&
        lhs.useGlassEffect == rhs.useGlassEffect &&
        lhs.clearBackground == rhs.clearBackground &&
        lhs.cornerRadius == rhs.cornerRadius &&
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.minWidth == rhs.minWidth &&
        lhs.minHeight == rhs.minHeight &&
        lhs.horizontalPadding == rhs.horizontalPadding &&
        lhs.verticalPadding == rhs.verticalPadding &&
        lhs.shadowRadius == rhs.shadowRadius &&
        lhs.isBlocking == rhs.isBlocking &&
        lhs.backdropOpacity == rhs.backdropOpacity
    }
}

// MARK: - Presets
public extension ProgressOverlayConfiguration {
    /// Default configuration with dark background
    static let `default` = ProgressOverlayConfiguration()

    /// Glass effect configuration (iOS 26+)
    static let glass = ProgressOverlayConfiguration(
        backgroundColor: .clear,
        useGlassEffect: true,
        cornerRadius: 20
    )

    /// Light colored configuration
    static let light = ProgressOverlayConfiguration(
        backgroundColor: .white,
        backgroundOpacity: 0.95
    )

    /// Minimal configuration with small size
    static let minimal = ProgressOverlayConfiguration(
        minWidth: 80,
        minHeight: 80,
        horizontalPadding: 16,
        verticalPadding: 16
    )

    /// Large configuration
    static let large = ProgressOverlayConfiguration(
        minWidth: 200,
        minHeight: 200,
        horizontalPadding: 32,
        verticalPadding: 32
    )

    /// Clear background (only shows content)
    static let clear = ProgressOverlayConfiguration(
        backgroundColor: .clear,
        clearBackground: true,
        shadowRadius: 0
    )

    /// Non-blocking (allows interaction with content below)
    static let nonBlocking = ProgressOverlayConfiguration(
        isBlocking: false
    )

    /// Roomy, dimmed panel for celebrations: personal bests, streaks, finished challenges.
    static let celebration = ProgressOverlayConfiguration(
        cornerRadius: 28,
        minWidth: 280,
        minHeight: 280,
        horizontalPadding: 28,
        verticalPadding: 32,
        isBlocking: true,
        backdropOpacity: 0.55
    )
}
