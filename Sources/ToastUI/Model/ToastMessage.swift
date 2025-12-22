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
    public let message: String?
    public let type: ToastType
    public let duration: TimeInterval
    public let alignment: ToastAlignment
    public let customIcon: AnyView?
    public let backgroundColor: Color?
    public let configuration: ToastConfiguration
    public let showCloseButton: Bool
    public let enableCopy: Bool
    
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
        enableCopy: Bool = false
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
            enableCopy: enableCopy
        )
    }
    
    // Helper method to update title
    public mutating func updateTitle(_ newTitle: String) {
        self.title = newTitle
    }
}
