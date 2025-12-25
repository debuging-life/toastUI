//
//  UIOverlayModifier.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 24/12/25.
//

import SwiftUI

/// A view modifier that displays an overlay based on UI state
public struct UIOverlayModifier<OverlayContent: View>: ViewModifier {
    @Binding var state: UIState
    let isBlocking: Bool
    let onRetry: (@MainActor () async -> Void)?

    @ViewBuilder let overlay: (_ state: UIState, _ retry: (@MainActor () async -> Void)?, _ dismiss: @escaping () -> Void) -> OverlayContent

    private var shouldShowOverlay: Bool {
        switch state {
        case .idle:
            return false
        case .loading, .empty, .failure, .success, .custom, .rive:
            return true
        }
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isBlocking && shouldShowOverlay)

            if shouldShowOverlay {
                overlay(state, onRetry) {
                    state = .idle
                }
                .allowsHitTesting(isBlocking)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .zIndex(999)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: state)
    }
}

// MARK: - View Extension

public extension View {
    /// Adds a UI overlay that responds to different states (loading, empty, failure, success)
    /// - Parameters:
    ///   - state: Binding to the current UI state
    ///   - configuration: Overlay appearance and behavior configuration
    ///   - isBlocking: Whether the overlay should block user interaction with the underlying content
    ///   - onRetry: Optional retry handler for failure state
    /// - Returns: A view with the overlay modifier applied
    func uiOverlay(
        state: Binding<UIState>,
        configuration: UIOverlayConfiguration = .default,
        isBlocking: Bool = true,
        onRetry: (@MainActor () async -> Void)? = nil
    ) -> some View {
        modifier(
            UIOverlayModifier(
                state: state,
                isBlocking: isBlocking,
                onRetry: onRetry,
                overlay: { state, retry, dismiss in
                    DefaultUIOverlay(
                        state: state,
                        retry: retry,
                        configuration: configuration,
                        onDismiss: dismiss
                    )
                }
            )
        )
    }

    /// Adds a custom UI overlay with your own view
    /// - Parameters:
    ///   - state: Binding to the current UI state
    ///   - isBlocking: Whether the overlay should block user interaction
    ///   - onRetry: Optional retry handler
    ///   - overlay: Custom overlay view builder
    /// - Returns: A view with the custom overlay modifier applied
    func uiOverlay<OverlayContent: View>(
        state: Binding<UIState>,
        isBlocking: Bool = true,
        onRetry: (@MainActor () async -> Void)? = nil,
        @ViewBuilder overlay: @escaping (_ state: UIState, _ retry: (@MainActor () async -> Void)?, _ dismiss: @escaping () -> Void) -> OverlayContent
    ) -> some View {
        modifier(
            UIOverlayModifier(
                state: state,
                isBlocking: isBlocking,
                onRetry: onRetry,
                overlay: overlay
            )
        )
    }
}
