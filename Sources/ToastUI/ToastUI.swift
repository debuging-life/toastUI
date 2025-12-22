
//
//  ToastView.swift
//  ToastPackage
//


import SwiftUI

struct ToastView: View {
    let toast: ToastMessage
    let onDismiss: () -> Void
    @State private var showCopiedFeedback = false
    
    private var effectiveBackgroundColor: Color {
        toast.backgroundColor ?? toast.type.color
    }
    
    var body: some View {
        if toast.type == .progress {
            progressView
        } else {
            standardView
        }
    }
    
    // MARK: - Progress View
    private var progressView: some View {
        HStack(spacing: 12) {
            ProgressView()
                .tint(.white)
            
            Text(toast.title)
                .font(.headline)
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.horizontal, toast.configuration.horizontalPadding)
        .padding(.vertical, toast.configuration.verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: toast.configuration.cornerRadius)
                .fill(effectiveBackgroundColor.gradient)
                .shadow(
                    color: toast.configuration.shadowColor,
                    radius: toast.configuration.shadowRadius,
                    x: toast.configuration.shadowX,
                    y: toast.configuration.shadowY
                )
        )
        .padding(.horizontal)
    }
    
    // MARK: - Standard View
    private var standardView: some View {
        HStack(spacing: 12) {
            // Icon
            if let customIcon = toast.customIcon {
                customIcon
                    .frame(width: 24, height: 24)
            } else {
                Image(systemName: toast.type.defaultIcon)
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(toast.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                if let message = toast.message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(3)
                }
            }
            
            Spacer()
            
            // Action buttons
            HStack(spacing: 12) {
                // Copy button
                if toast.enableCopy {
                    Button(action: copyToClipboard) {
                        ZStack {
                            Image(systemName: "doc.on.doc")
                                .opacity(showCopiedFeedback ? 0 : 1)
                            
                            Image(systemName: "checkmark")
                                .opacity(showCopiedFeedback ? 1 : 0)
                        }
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                        .animation(.spring(duration: 0.3), value: showCopiedFeedback)
                    }
                }
                
                // Close button
                if toast.showCloseButton {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
        }
        .padding(.horizontal, toast.configuration.horizontalPadding)
        .padding(.vertical, toast.configuration.verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: toast.configuration.cornerRadius)
                .fill(effectiveBackgroundColor.gradient)
                .shadow(
                    color: toast.configuration.shadowColor,
                    radius: toast.configuration.shadowRadius,
                    x: toast.configuration.shadowX,
                    y: toast.configuration.shadowY
                )
        )
        .padding(.horizontal)
    }
    
    // MARK: - Copy Function
    
    private func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = toast.copyableText
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(toast.copyableText, forType: .string)
        #endif
        
        // Show feedback
        withAnimation(.spring(duration: 0.3)) {
            showCopiedFeedback = true
        }
        
        // Reset after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.spring(duration: 0.3)) {
                showCopiedFeedback = false
            }
        }
    }
}
