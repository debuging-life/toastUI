
import SwiftUI

public struct ToastView: View {
    let toast: ToastModel
    
    public init(toast: ToastModel) {
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

#Preview {
    ToastView(toast: ToastModel(message: "Test", type: .success))
}
