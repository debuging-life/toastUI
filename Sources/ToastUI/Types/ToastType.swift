//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//

import SwiftUI

public enum ToastType {
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
        case .success: return "Success"
        case .error: return "Error"
        case .warning: return "Warning"
        case .info: return nil
        case .progress: return "In progress"
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
