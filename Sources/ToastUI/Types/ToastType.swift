//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//

import SwiftUI

public enum ToastType: Hashable, Sendable {
    case success
    case error
    case warning
    case info
    case progress
    case glass

    var defaultIcon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        case .progress: return "arrow.clockwise.circle.fill"
        case .glass: return "sparkles"
        }
    }

    /// Spoken before the title, since colour alone means nothing to VoiceOver.
    var accessibilityPrefix: String? {
        switch self {
        case .success: return L10n.success
        case .error: return L10n.error
        case .warning: return L10n.warning
        case .info: return nil
        case .progress: return L10n.inProgress
        case .glass: return nil
        }
    }

    /// Used when the stack is full: a failure outranks an update.
    var priority: Int {
        switch self {
        case .error: return 3
        case .warning: return 2
        case .success, .progress: return 1
        case .info, .glass: return 0
        }
    }

    var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        case .progress: return .purple
        case .glass: return .clear
        }
    }
}
