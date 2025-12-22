//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//

import SwiftUI

public struct ToastMessage: Identifiable, Equatable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let type: ToastType
    public let duration: TimeInterval
    public let alignment: ToastAlignment
    public let customIcon: AnyView?
    public let backgroundColor: Color?
    
    public init(
        title: String,
        message: String? = nil,
        type: ToastType,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        customIcon: AnyView? = nil,
        backgroundColor: Color? = nil
    ) {
        self.title = title
        self.message = message
        self.type = type
        self.duration = duration
        self.alignment = alignment
        self.customIcon = customIcon
        self.backgroundColor = backgroundColor
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
        @ViewBuilder icon: () -> Icon
    ) {
        self.init(
            title: title,
            message: message,
            type: type,
            duration: duration,
            alignment: alignment,
            customIcon: AnyView(icon()),
            backgroundColor: backgroundColor
        )
    }
}
