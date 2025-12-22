
//
//  ToastView.swift
//  ToastPackage
//


import SwiftUI

struct ToastView: View {
    let toast: ToastMessage
    let onDismiss: () -> Void
    
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
    
    // MARK: - Progress View (Simplified - No Close Button)
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
    
    // MARK: - Standard View (with icon and optional message)
    private var standardView: some View {
        HStack(spacing: 12) {
            // Icon (custom or default)
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
                }
            }
            
            Spacer()
            
            // Dismiss button (optional)
            if toast.showCloseButton {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
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
}
