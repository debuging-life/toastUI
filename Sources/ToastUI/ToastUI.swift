
//
//  ToastView.swift
//  ToastPackage
//
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
    
    // MARK: - Progress View (Simplified)
    private var progressView: some View {
        HStack(spacing: 12) {
            ProgressView()
                .tint(.white)
            
            Text(toast.title)
                .font(.headline)
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(effectiveBackgroundColor.gradient)
                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
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
            
            // Dismiss button
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(effectiveBackgroundColor.gradient)
                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
        )
        .padding(.horizontal)
    }
}
