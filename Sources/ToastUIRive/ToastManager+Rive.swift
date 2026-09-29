//
//  ToastManager+Rive.swift
//  ToastUIRive
//

import SwiftUI
import ToastUI

public extension ToastManager {

    // MARK: - Toasts

    /// A toast whose icon is a Rive animation.
    ///
    ///     toast.presentRive(title: "Run saved", animation: .init(asset: "check", fallbackSymbol: "checkmark.circle.fill"), type: .success)
    @MainActor
    func presentRive(
        title: String,
        message: String? = nil,
        animation: RiveAnimationSource,
        type: ToastType = .info,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        iconSize: CGFloat = 28,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false
    ) {
        present(
            title: title,
            message: message,
            type: type,
            duration: duration,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton,
            enableCopy: enableCopy
        ) {
            RiveAnimationView(animation, size: iconSize, tint: .white)
        }
    }

    // MARK: - Loading

    /// A loading overlay whose spinner is a Rive animation.
    ///
    /// Give the source a `progressInput` and call ``updateProgressOverlay(progress:title:message:)``
    /// to drive it from real progress; leave `progress` nil for a looping animation.
    @MainActor
    func showRiveProgressOverlay(
        animation: RiveAnimationSource,
        title: String? = nil,
        message: String? = nil,
        size: CGFloat = 120,
        position: ProgressOverlayPosition = .center,
        configuration: ProgressOverlayConfiguration = .default,
        progress: Double? = nil,
        dismissible: Bool = false,
        onCancel: (() -> Void)? = nil
    ) {
        showProgressOverlay(
            title: title,
            message: message,
            position: position,
            configuration: configuration,
            dismissible: dismissible,
            progress: progress,
            onCancel: onCancel
        ) {
            RiveOverlayContent(manager: self, animation: animation, size: size)
        }
    }

    // MARK: - Celebration

    /// A full-screen moment for personal bests, streaks and finished challenges.
    /// It blocks, waits for the user, and runs `onDismiss` when they tap the button.
    @MainActor
    func showRiveCelebration(
        animation: RiveAnimationSource,
        title: String,
        message: String? = nil,
        actionTitle: String = "Nice!",
        size: CGFloat = 220,
        onDismiss: (() -> Void)? = nil
    ) {
        showProgressOverlay(
            position: .center,
            configuration: .celebration,
            dismissible: false
        ) {
            RiveCelebrationContent(
                animation: animation,
                title: title,
                message: message,
                actionTitle: actionTitle,
                size: size
            ) { [weak self] in
                self?.dismissProgressOverlay()
                onDismiss?()
            }
        }
    }
}

// MARK: - Overlay contents

/// Reads the live overlay so progress updates reach the state machine.
private struct RiveOverlayContent: View {
    @ObservedObject var manager: ToastManager
    let animation: RiveAnimationSource
    let size: CGFloat

    var body: some View {
        VStack(spacing: 12) {
            RiveAnimationView(animation, size: size, progress: manager.progressOverlay?.progress)

            if let title = manager.progressOverlay?.title {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            if let message = manager.progressOverlay?.message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

private struct RiveCelebrationContent: View {
    let animation: RiveAnimationSource
    let title: String
    let message: String?
    let actionTitle: String
    let size: CGFloat
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            RiveAnimationView(animation, size: size)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title.weight(.heavy))
                    .multilineTextAlignment(.center)
                if let message {
                    Text(message)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            Button(actionTitle, action: onDone)
                .font(.headline)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .buttonBorderShape(.capsule)
        }
        .padding(8)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }
}
