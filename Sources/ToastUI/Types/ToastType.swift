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
