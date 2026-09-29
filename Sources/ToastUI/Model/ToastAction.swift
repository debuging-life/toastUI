//
//  ToastAction.swift
//  ToastUI
//

import SwiftUI

/// A button shown inside a toast: "Undo", "Retry", "View".
public struct ToastAction: Sendable {
    public let title: String
    public let handler: @MainActor () -> Void
    /// Whether tapping it also dismisses the toast.
    public let dismissesToast: Bool

    public init(title: String, dismissesToast: Bool = true, handler: @escaping @MainActor () -> Void) {
        self.title = title
        self.dismissesToast = dismissesToast
        self.handler = handler
    }
}
