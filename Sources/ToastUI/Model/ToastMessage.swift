//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//


import SwiftUI

public struct ToastMessage: Identifiable, Equatable {
    public let id = UUID()
    public var title: String
    public var message: String?
    public let type: ToastType
    public let duration: TimeInterval
    public let alignment: ToastAlignment
    public let customIcon: AnyView?
    public let backgroundColor: Color?
    public let configuration: ToastConfiguration
    public let showCloseButton: Bool
    public let enableCopy: Bool
    /// Toasts sharing a group replace each other instead of stacking — the fix for
    /// "GPS signal lost" firing ten times on one run.
    public let groupID: String?
    /// Stays until it is dismissed, for "You're offline" and similar.
    public let isSticky: Bool
    /// Tapping the body runs this (open the run that just synced).
    public let onTap: (@MainActor () -> Void)?
    /// A button inside the toast: Undo, Retry, View.
    public let action: ToastAction?
    /// Overrides `ToastManager.hapticsEnabled` for this one toast: true always plays,
    /// false never does, nil follows the app-wide setting.
    public let playsHaptic: Bool?

    public init(
        title: String,
        message: String? = nil,
        type: ToastType,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        customIcon: AnyView? = nil,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false,
        groupID: String? = nil,
        isSticky: Bool = false,
        onTap: (@MainActor () -> Void)? = nil,
        action: ToastAction? = nil,
        playsHaptic: Bool? = nil
    ) {
        self.title = title
        self.message = message
        self.type = type
        self.duration = duration
        self.alignment = alignment
        self.customIcon = customIcon
        self.backgroundColor = backgroundColor
        self.configuration = configuration
        self.showCloseButton = showCloseButton
        self.enableCopy = enableCopy
        self.groupID = groupID
        self.isSticky = isSticky
        self.onTap = onTap
        self.action = action
        self.playsHaptic = playsHaptic
    }
    
    /// What VoiceOver reads when the toast appears.
    public var accessibilityText: String {
        [type.accessibilityPrefix, title, message].compactMap { $0 }.joined(separator: ". ")
    }

    public var copyableText: String {
        if let message = message {
            return "\(title)\n\(message)"
        }
        return title
    }
    
    public static func == (lhs: ToastMessage, rhs: ToastMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Convenience Initializers with Custom Icon
public extension ToastMessage {
    init<Icon: View>(
        title: String,
        message: String? = nil,
        type: ToastType,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false,
        groupID: String? = nil,
        isSticky: Bool = false,
        onTap: (@MainActor () -> Void)? = nil,
        action: ToastAction? = nil,
        playsHaptic: Bool? = nil,
        @ViewBuilder icon: () -> Icon
    ) {
        self.init(
            title: title,
            message: message,
            type: type,
            duration: duration,
            alignment: alignment,
            customIcon: AnyView(icon()),
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton,
            enableCopy: enableCopy,
            groupID: groupID,
            isSticky: isSticky,
            onTap: onTap,
            action: action,
            playsHaptic: playsHaptic
        )
    }
    
    // Helper method to update title
    mutating func updateTitle(_ newTitle: String) {
        self.title = newTitle
    }

    mutating func updateMessage(_ newMessage: String?) {
        self.message = newMessage
    }
}
