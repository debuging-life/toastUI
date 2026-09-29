//
//  ProgressOverlayMessage.swift
//  ToastUI
//
//  Created by Pardip Bhatti
//

import SwiftUI

/// Message model for progress overlay
public struct ProgressOverlayMessage: Identifiable, Equatable {
    public let id = UUID()
    public var title: String?
    public var message: String?
    public let position: ProgressOverlayPosition
    public let configuration: ProgressOverlayConfiguration
    public let customView: AnyView?
    public let dismissible: Bool
    public let onDismiss: (() -> Void)?
    /// 0...1 for a determinate ring, nil for an indeterminate spinner.
    public var progress: Double?
    /// Shows a "Cancel" button that runs this, for uploads and long syncs.
    public let onCancel: (() -> Void)?

    public init(
        title: String? = nil,
        message: String? = nil,
        position: ProgressOverlayPosition = .center,
        configuration: ProgressOverlayConfiguration = .default,
        customView: AnyView? = nil,
        dismissible: Bool = false,
        progress: Double? = nil,
        onCancel: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.position = position
        self.configuration = configuration
        self.customView = customView
        self.dismissible = dismissible
        self.progress = progress
        self.onCancel = onCancel
        self.onDismiss = onDismiss
    }

    /// Everything the content needs, without the identity that would restart animations.
    public var contentKey: String {
        "\(title ?? "")|\(message ?? "")|\(progress.map { String(format: "%.3f", $0) } ?? "")"
    }

    public static func == (lhs: ProgressOverlayMessage, rhs: ProgressOverlayMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Convenience Initializers with Custom View
public extension ProgressOverlayMessage {
    init<Content: View>(
        title: String? = nil,
        message: String? = nil,
        position: ProgressOverlayPosition = .center,
        configuration: ProgressOverlayConfiguration = .default,
        dismissible: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder customView: () -> Content
    ) {
        self.init(
            title: title,
            message: message,
            position: position,
            configuration: configuration,
            customView: AnyView(customView()),
            dismissible: dismissible,
            onDismiss: onDismiss
        )
    }
}
