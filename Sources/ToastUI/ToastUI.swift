
import SwiftUI

public struct Toast: Equatable {
    public enum ToastType {
        case success
        case error
        case warning
        case info
    }
    
    public let message: String
    public let type: ToastType
    public let duration: TimeInterval
    
    public init(message: String, type: ToastType, duration: TimeInterval = 3) {
        self.message = message
        self.type = type
        self.duration = duration
    }
}

public struct ToastView: View {
    let toast: Toast
    
    public init(toast: Toast) {
        self.toast = toast
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .font(.system(size: 20))
            
            Text(toast.message)
                .foregroundColor(.white)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
    
    private var iconName: String {
        switch toast.type {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    private var backgroundColor: Color {
        switch toast.type {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}
