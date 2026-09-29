//
//  ProgressOverlayView.swift
//  ToastUI
//

import SwiftUI

struct ProgressOverlayView: View {
    let overlay: ProgressOverlayMessage
    let onDismiss: () -> Void

    private var surface: ToastSurface {
        let configuration = overlay.configuration
        if configuration.useGlassEffect { return .glass }
        if configuration.clearBackground { return .clear }
        return .solid(configuration.backgroundColor.opacity(configuration.backgroundOpacity))
    }

    /// Text on a dark panel has to be white; on glass or clear it follows the system.
    private var textColor: Color {
        switch surface {
        case .glass, .clear: .primary
        case .solid(let color): color.isDarkish ? .white : .primary
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            content
        }
        .padding(.horizontal, overlay.configuration.horizontalPadding)
        .padding(.vertical, overlay.configuration.verticalPadding)
        .toastSurface(
            surface,
            cornerRadius: overlay.configuration.cornerRadius,
            shadow: (overlay.configuration.shadowColor,
                     overlay.configuration.shadowRadius,
                     overlay.configuration.shadowX,
                     overlay.configuration.shadowY)
        )
        .frame(width: overlay.configuration.width, height: overlay.configuration.height)
        .frame(
            minWidth: overlay.configuration.width == nil ? overlay.configuration.minWidth : nil,
            minHeight: overlay.configuration.height == nil ? overlay.configuration.minHeight : nil
        )
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(overlay.configuration.isBlocking ? .isModal : [])
    }

    @ViewBuilder
    private var content: some View {
        if let customView = overlay.customView {
            customView
        } else {
            VStack(spacing: 12) {
                if let progress = overlay.progress {
                    DeterminateRing(progress: progress, tint: textColor)
                        .frame(width: 56, height: 56)
                        .accessibilityLabel(overlay.title ?? L10n.progress)
                        .accessibilityValue(L10n.percent(Int(progress * 100)))
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                        .tint(textColor)
                        .accessibilityLabel(overlay.title ?? L10n.loading)
                }

                if let title = overlay.title {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(textColor)
                        .multilineTextAlignment(.center)
                }

                if let message = overlay.message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(textColor.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
        }

        if let onCancel = overlay.onCancel {
            Button(L10n.cancel, action: onCancel)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(textColor)
                .padding(.top, 4)
        }

        if overlay.dismissible {
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(textColor.opacity(0.7))
            }
            .accessibilityLabel(L10n.dismiss)
            .padding(.top, 8)
        }
    }
}

/// The ring used when the caller reports real progress.
private struct DeterminateRing: View {
    let progress: Double
    let tint: Color

    private var clamped: Double { min(max(progress, 0), 1) }

    var body: some View {
        ZStack {
            Circle().stroke(tint.opacity(0.2), lineWidth: 5)
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(tint, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.25), value: clamped)
            Text("\(Int(clamped * 100))%")
                .font(.caption.weight(.semibold).monospacedDigit())
                .foregroundStyle(tint)
        }
    }
}
