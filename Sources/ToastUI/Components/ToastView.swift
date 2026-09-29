//
//  ToastView.swift
//  ToastUI
//

import SwiftUI

struct ToastView: View {
    let toast: ToastMessage
    var theme: ToastTheme = .default
    /// Draws the countdown only while the toast is really counting down.
    var isCountingDown = true
    let onDismiss: () -> Void

    @State private var showCopiedFeedback = false
    @State private var dragOffset: CGFloat = 0

    private var surface: ToastSurface {
        if toast.type == .glass { return .glass }
        return .solid(toast.backgroundColor ?? theme.color(for: toast.type))
    }

    /// An Undo toast with a visible deadline: the bar drains as the time runs out.
    private var showsCountdown: Bool {
        theme.showsCountdownOnActionToasts
            && toast.action != nil
            && !toast.isSticky
            && isCountingDown
            && toast.duration.isFinite
    }

    var body: some View {
        HStack(spacing: 12) {
            leading

            VStack(alignment: .leading, spacing: 4) {
                Text(toast.title)
                    .font(.headline)
                    .foregroundStyle(surface.foreground)

                if let message = toast.message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(surface.secondaryForeground)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let action = toast.action {
                Button(action.title) {
                    action.handler()
                    if action.dismissesToast { onDismiss() }
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(surface.foreground)
                .buttonStyle(.plain)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(surface.foreground.opacity(0.15))
                )
            }

            actions
        }
        .padding(.horizontal, toast.configuration.horizontalPadding)
        .padding(.vertical, toast.configuration.verticalPadding)
        .overlay(alignment: .bottom) {
            if showsCountdown {
                CountdownBar(duration: toast.duration, tint: surface.foreground)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 6)
            }
        }
        .toastSurface(
            surface,
            cornerRadius: toast.configuration.cornerRadius,
            shadow: (toast.configuration.shadowColor,
                     toast.configuration.shadowRadius,
                     toast.configuration.shadowX,
                     toast.configuration.shadowY)
        )
        .padding(.horizontal)
        .offset(y: dragOffset)
        .opacity(dragOpacity)
        .contentShape(.rect)
        .onTapGesture {
            guard let onTap = toast.onTap else { return }
            onTap()
            onDismiss()
        }
        .gesture(dismissDrag)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(toast.accessibilityText)
        .accessibilityAction(named: Text(L10n.dismiss), onDismiss)
    }

    /// Flick a toast away: up for the top stack, down for the bottom one.
    private var dismissDrag: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                let translation = value.translation.height
                switch toast.alignment {
                case .top: dragOffset = min(translation, 12)
                case .bottom: dragOffset = max(translation, -12)
                case .center: dragOffset = translation / 3
                }
            }
            .onEnded { value in
                let translation = value.translation.height
                let dismissed = switch toast.alignment {
                case .top: translation < -40
                case .bottom: translation > 40
                case .center: abs(translation) > 60
                }
                if dismissed {
                    onDismiss()
                } else {
                    withAnimation(.spring(duration: 0.25)) { dragOffset = 0 }
                }
            }
    }

    private var dragOpacity: Double {
        max(1 - Double(abs(dragOffset)) / 60, 0.4)
    }

    // MARK: - Pieces

    @ViewBuilder
    private var leading: some View {
        if toast.type == .progress {
            ProgressView()
                .tint(surface.foreground)
                .accessibilityHidden(true)
        } else if let customIcon = toast.customIcon {
            customIcon
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)
        } else {
            Image(systemName: toast.type.defaultIcon)
                .font(.title2)
                .foregroundStyle(surface.foreground)
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private var actions: some View {
        HStack(spacing: 12) {
            if toast.enableCopy, Self.supportsClipboard {
                Button(action: copyToClipboard) {
                    ZStack {
                        Image(systemName: "doc.on.doc")
                            .opacity(showCopiedFeedback ? 0 : 1)
                        Image(systemName: "checkmark")
                            .opacity(showCopiedFeedback ? 1 : 0)
                    }
                    .font(.caption)
                    .foregroundStyle(surface.foreground.opacity(0.7))
                    .animation(.spring(duration: 0.3), value: showCopiedFeedback)
                }
                .accessibilityLabel(showCopiedFeedback ? L10n.copied : L10n.copyMessage)
            }

            if toast.showCloseButton {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundStyle(surface.foreground.opacity(0.7))
                }
                .accessibilityLabel(L10n.dismiss)
            }
        }
    }

    // MARK: - Copy

    /// watchOS has no pasteboard.
    static var supportsClipboard: Bool {
        #if os(iOS) || os(macOS)
        true
        #else
        false
        #endif
    }

    private func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = toast.copyableText
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(toast.copyableText, forType: .string)
        #endif

        withAnimation(.spring(duration: 0.3)) { showCopiedFeedback = true }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.5))
            withAnimation(.spring(duration: 0.3)) { showCopiedFeedback = false }
        }
    }
}

/// A hairline that drains over the toast's lifetime, so an Undo window is visible.
private struct CountdownBar: View {
    let duration: TimeInterval
    let tint: Color

    @State private var remaining: CGFloat = 1

    var body: some View {
        GeometryReader { geometry in
            Capsule()
                .fill(tint.opacity(0.6))
                .frame(width: geometry.size.width * remaining, height: 2)
        }
        .frame(height: 2)
        .onAppear {
            withAnimation(.linear(duration: duration)) { remaining = 0 }
        }
        .accessibilityHidden(true)
    }
}
