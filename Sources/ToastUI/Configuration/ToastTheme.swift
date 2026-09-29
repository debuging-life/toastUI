//
//  ToastTheme.swift
//  ToastUI
//

import SwiftUI

/// Set once, applied to everything this manager shows, so call sites stay short:
///
///     ContentView().setupToastUI(theme: .trakly)
///     toast.success(title: "Saved")     // already branded
public struct ToastTheme: Sendable {
    /// Shape, padding and shadow of a toast.
    public var toast: ToastConfiguration
    /// Look of the loading panel.
    public var overlay: ProgressOverlayConfiguration
    /// Colour per toast type. Anything omitted falls back to the type's own colour.
    public var colors: [ToastType: Color]
    public var defaultAlignment: ToastAlignment
    public var defaultDuration: TimeInterval
    /// Animation used when toasts come and go.
    public var animation: Animation
    /// Shown behind an Undo-style action so people can see the window closing.
    public var showsCountdownOnActionToasts: Bool

    public init(toast: ToastConfiguration = .default,
                overlay: ProgressOverlayConfiguration = .default,
                colors: [ToastType: Color] = [:],
                defaultAlignment: ToastAlignment = .top,
                defaultDuration: TimeInterval = 3,
                animation: Animation = .spring(response: 0.35, dampingFraction: 0.75),
                showsCountdownOnActionToasts: Bool = true) {
        self.toast = toast
        self.overlay = overlay
        self.colors = colors
        self.defaultAlignment = defaultAlignment
        self.defaultDuration = defaultDuration
        self.animation = animation
        self.showsCountdownOnActionToasts = showsCountdownOnActionToasts
    }

    public static let `default` = ToastTheme()

    /// The colour a toast of this type should use.
    public func color(for type: ToastType) -> Color {
        colors[type] ?? type.color
    }
}
