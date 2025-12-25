
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

    private var supportsGlassEffect: Bool {
        DeviceCapabilities.supportsGlassEffect
    }

    var body: some View {
        if toast.type == .progress {
            progressView
        } else if toast.type == .glass {
            if supportsGlassEffect {
                if #available(iOS 26.0, *) {
                    glassView
                } else {
                    fallbackGlassView
                }
            } else {
                fallbackGlassView
            }
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
    
    // MARK: - Glass Effect View (iOS 26+)
    @available(iOS 26.0, *)
    private var glassView: some View {
        HStack(spacing: 12) {
            // Icon
            if let customIcon = toast.customIcon {
                customIcon
                    .frame(width: 24, height: 24)
            } else {
                Image(systemName: toast.type.defaultIcon)
                    .font(.title2)
                    .foregroundStyle(.primary)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(toast.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if let message = toast.message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
                        .foregroundStyle(.secondary)
                        .animation(.spring(duration: 0.3), value: showCopiedFeedback)
                    }
                }

                // Close button
                if toast.showCloseButton {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, toast.configuration.horizontalPadding)
        .padding(.vertical, toast.configuration.verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: toast.configuration.cornerRadius)
                .fill(.ultraThinMaterial)
                .shadow(
                    color: toast.configuration.shadowColor,
                    radius: toast.configuration.shadowRadius,
                    x: toast.configuration.shadowX,
                    y: toast.configuration.shadowY
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: toast.configuration.cornerRadius)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }

    // MARK: - Fallback Glass View (iOS < 26)
    private var fallbackGlassView: some View {
        HStack(spacing: 12) {
            // Icon
            if let customIcon = toast.customIcon {
                customIcon
                    .frame(width: 24, height: 24)
            } else {
                Image(systemName: toast.type.defaultIcon)
                    .font(.title2)
                    .foregroundStyle(.primary)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(toast.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if let message = toast.message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
                        .foregroundStyle(.secondary)
                        .animation(.spring(duration: 0.3), value: showCopiedFeedback)
                    }
                }

                // Close button
                if toast.showCloseButton {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.horizontal, toast.configuration.horizontalPadding)
        .padding(.vertical, toast.configuration.verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: toast.configuration.cornerRadius)
                .fill(.regularMaterial)
                .shadow(
                    color: toast.configuration.shadowColor,
                    radius: toast.configuration.shadowRadius,
                    x: toast.configuration.shadowX,
                    y: toast.configuration.shadowY
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: toast.configuration.cornerRadius)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
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
