//
//  DefaultUIOverlay.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 24/12/25.
//

import SwiftUI
import RiveRuntime

/// Default overlay view that displays different states with glass effect on iOS 26+
public struct DefaultUIOverlay: View {
    let state: UIState
    let retry: (@MainActor () async -> Void)?
    let configuration: UIOverlayConfiguration
    let onDismiss: (() -> Void)?

    @State private var isAnimating = false

    private var supportsGlassEffect: Bool {
        DeviceCapabilities.supportsGlassEffect
    }

    public init(
        state: UIState,
        retry: (@MainActor () async -> Void)? = nil,
        configuration: UIOverlayConfiguration = .default,
        onDismiss: (() -> Void)? = nil
    ) {
        self.state = state
        self.retry = retry
        self.configuration = configuration
        self.onDismiss = onDismiss
    }

    public var body: some View {
        ZStack {
            // Semi-transparent backdrop
            Rectangle()
                .fill(.black.opacity(configuration.backdropOpacity))
                .ignoresSafeArea()

            // Content card
            switch configuration.style {
            case .glass(_, _, _, _):
                if supportsGlassEffect {
                    if #available(iOS 26.0, *) {
                        glassContentView
                    } else {
                        regularContentView
                    }
                } else {
                    regularContentView
                }
            case .solid(let backgroundColor, let opacity, _, _, _):
                solidContentView(color: backgroundColor, opacity: opacity)
            }
        }
        .task(id: state) {
            await handleAutoDismiss()
        }
    }

    // MARK: - Glass Effect Content (iOS 26+)

    @available(iOS 26.0, *)
    private var glassContentView: some View {
        let intensity = configuration.glassIntensity ?? .ultraThin
        return contentView
            .padding(24)
            .frame(maxWidth: configuration.maxWidth)
            .background(
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .fill(intensity.material)
            )
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 30, x: 0, y: 10)
            .padding()
    }

    // MARK: - Regular Material Content (iOS < 26)

    private var regularContentView: some View {
        let intensity = configuration.glassIntensity ?? .regular
        return contentView
            .padding(24)
            .frame(maxWidth: configuration.maxWidth)
            .background(
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .fill(intensity.material)
            )
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 25, x: 0, y: 8)
            .padding()
    }

    // MARK: - Solid Color Content

    private func solidContentView(color: Color, opacity: Double) -> some View {
        contentView
            .padding(24)
            .frame(maxWidth: configuration.maxWidth)
            .background(
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .fill(color.opacity(opacity))
            )
            .overlay(
                RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 25, x: 0, y: 8)
            .padding()
    }

    // MARK: - Content View

    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 16) {
            // Close button (top-right for dismissible states)
            if configuration.showCloseButton && isDismissibleState {
                HStack {
                    Spacer()
                    closeButton
                }
                .padding(.bottom, -8)
            }

            switch state {
            case .loading(let message, let loader):
                loadingView(message: message, customLoader: loader)

            case .empty(let message, let icon):
                emptyView(message: message, customIcon: icon)

            case .failure(let message, let icon):
                failureView(message: message, customIcon: icon)

            case .success(let message, let icon):
                successView(message: message, customIcon: icon)

            case .custom(_, let view):
                view

            case .rive(_, let riveName, let stateMachineName, let animationName, let title, let message):
                riveView(
                    riveName: riveName,
                    stateMachineName: stateMachineName,
                    animationName: animationName,
                    title: title,
                    message: message
                )

            case .idle:
                EmptyView()
            }
        }
    }

    // MARK: - Close Button

    private var closeButton: some View {
        Button {
            onDismiss?()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.primary.opacity(0.1))
                )
        }
        .buttonStyle(.plain)
    }

    private var isDismissibleState: Bool {
        switch state {
        case .idle, .loading:
            return false
        case .empty, .failure, .success, .custom, .rive:
            return true
        }
    }

    // MARK: - State Views

    private func loadingView(message: String?, customLoader: AnyView?) -> some View {
        VStack(spacing: 16) {
            // Use custom loader if provided, otherwise use default
            if let customLoader = customLoader {
                customLoader
                    .frame(width: 60, height: 60)
            } else {
                // Default animated loading indicator
                ZStack {
                    Circle()
                        .stroke(Color.primary.opacity(0.1), lineWidth: 4)
                        .frame(width: 60, height: 60)

                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            .linear(duration: 1.0).repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                        .onAppear { isAnimating = true }
                }
            }

            VStack(spacing: 6) {
                Text(message ?? "Loading...")
                    .font(configuration.titleStyle.font)
                    .fontWeight(configuration.titleStyle.fontWeight)
                    .foregroundStyle(configuration.titleStyle.color)

                Text("Please wait")
                    .font(configuration.messageStyle.font)
                    .fontWeight(configuration.messageStyle.fontWeight)
                    .foregroundStyle(configuration.messageStyle.color)
            }
        }
    }

    private func emptyView(message: String, customIcon: AnyView?) -> some View {
        VStack(spacing: 16) {
            // Empty state icon
            if let customIcon = customIcon {
                customIcon
                    .frame(width: 70, height: 70)
            } else {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 70, height: 70)

                    Image(systemName: "tray")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(.orange)
                }
            }

            VStack(spacing: 6) {
                Text(message)
                    .font(configuration.messageStyle.font)
                    .fontWeight(configuration.messageStyle.fontWeight)
                    .foregroundStyle(configuration.messageStyle.color)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private func failureView(message: String, customIcon: AnyView?) -> some View {
        VStack(spacing: 16) {
            // Error icon
            if let customIcon = customIcon {
                customIcon
                    .frame(width: 70, height: 70)
            } else {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 70, height: 70)

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(.red)
                }
            }

            VStack(spacing: 6) {
                Text("Something Went Wrong")
                    .font(configuration.titleStyle.font)
                    .fontWeight(configuration.titleStyle.fontWeight)
                    .foregroundStyle(configuration.titleStyle.color)

                Text(message)
                    .font(configuration.messageStyle.font)
                    .fontWeight(configuration.messageStyle.fontWeight)
                    .foregroundStyle(configuration.messageStyle.color)
                    .multilineTextAlignment(.center)
            }

            // Retry button
            if let retry = retry {
                Button {
                    Task { await retry() }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .semibold))

                        Text("Retry")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }

    private func successView(message: String, customIcon: AnyView?) -> some View {
        VStack(spacing: 16) {
            // Success icon
            if let customIcon = customIcon {
                customIcon
                    .frame(width: 70, height: 70)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .opacity(isAnimating ? 1.0 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isAnimating)
                    .onAppear {
                        isAnimating = true
                    }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 70, height: 70)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(.green)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .opacity(isAnimating ? 1.0 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isAnimating)
                        .onAppear {
                            isAnimating = true
                        }
                }
            }

            VStack(spacing: 6) {
                Text("Success!")
                    .font(configuration.titleStyle.font)
                    .fontWeight(configuration.titleStyle.fontWeight)
                    .foregroundStyle(configuration.titleStyle.color)

                Text(message)
                    .font(configuration.messageStyle.font)
                    .fontWeight(configuration.messageStyle.fontWeight)
                    .foregroundStyle(configuration.messageStyle.color)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Rive Animation View

    private func riveView(
        riveName: String,
        stateMachineName: String?,
        animationName: String?,
        title: String?,
        message: String?
    ) -> some View {
        VStack(spacing: 16) {
            // Rive animation
            if let stateMachineName = stateMachineName {
                RiveViewModel(fileName: riveName, stateMachineName: stateMachineName)
                    .view()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else if let animationName = animationName {
                RiveViewModel(fileName: riveName).view()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RiveViewModel(fileName: riveName).view()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Title and message
            if let title = title {
                VStack(spacing: 6) {
                    Text(title)
                        .font(configuration.titleStyle.font)
                        .fontWeight(configuration.titleStyle.fontWeight)
                        .foregroundStyle(configuration.titleStyle.color)

                    if let message = message {
                        Text(message)
                            .font(configuration.messageStyle.font)
                            .fontWeight(configuration.messageStyle.fontWeight)
                            .foregroundStyle(configuration.messageStyle.color)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }

    // MARK: - Auto Dismiss

    @MainActor
    private func handleAutoDismiss() async {
        guard let autoDismissAfter = configuration.autoDismissAfter else {
            return
        }
        guard isDismissibleState else {
            return
        }

        do {
            try await Task.sleep(nanoseconds: UInt64(autoDismissAfter * 1_000_000_000))
            onDismiss?()
        } catch {
            // Task was cancelled
        }
    }
}

// MARK: - Preview

#Preview("Loading") {
    struct PreviewWrapper: View {
        @State private var uiState: UIState = .loading(message: "Fetching data...")
        var body: some View {
            Color.gray.opacity(0.1)
                .uiOverlay(state: $uiState)
        }
    }
    return PreviewWrapper()
}

#Preview("Empty") {
    struct PreviewWrapper: View {
        @State private var uiState: UIState = .empty(message: "No items found")
        var body: some View {
            Color.gray.opacity(0.1)
                .uiOverlay(state: $uiState)
        }
    }
    return PreviewWrapper()
}

#Preview("Failure") {
    struct PreviewWrapper: View {
        @State private var uiState: UIState = .failure(message: "Network connection failed")
        var body: some View {
            Color.gray.opacity(0.1)
                .uiOverlay(state: $uiState, onRetry: {
                    // Retry action
                })
        }
    }
    return PreviewWrapper()
}

#Preview("Success") {
    struct PreviewWrapper: View {
        @State private var uiState: UIState = .success(message: "Data loaded successfully")
        var body: some View {
            Color.gray.opacity(0.1)
                .uiOverlay(state: $uiState)
        }
    }
    return PreviewWrapper()
}
