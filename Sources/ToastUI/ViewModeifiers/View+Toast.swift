//
//  View+Toast.swift
//  ToastUI
//

import SwiftUI

public extension View {
    /// Enables toast notifications for this view hierarchy.
    /// Apply this once, to your root view.
    ///
    /// On iOS the toasts live in their own pass-through window — one per scene, so
    /// iPad and Stage Manager show them in the right place. Elsewhere they are an
    /// overlay on this view.
    func setupToastUI(manager: ToastManager = .shared, theme: ToastTheme? = nil) -> some View {
        modifier(ToastSetupModifier(manager: manager, theme: theme))
    }
}

private struct ToastSetupModifier: ViewModifier {
    @ObservedObject var manager: ToastManager
    let theme: ToastTheme?

    @Environment(\.scenePhase) private var scenePhase

    func body(content: Content) -> some View {
        base(content)
            .onAppear { if let theme { manager.theme = theme } }
            // Nothing should time out while the app isn't on screen; a toast shown as
            // the user leaves would otherwise be gone when they come back.
            .onChange(of: scenePhase) { _, phase in
                manager.setAutoDismissPaused(phase != .active)
            }
    }

    @ViewBuilder
    private func base(_ content: Content) -> some View {
        #if os(iOS) || os(tvOS)
        content.background(
            ToastSceneReader { scene in
                ToastWindowManager.shared.setup(with: manager, in: scene)
            }
            .frame(width: 0, height: 0)
            .accessibilityHidden(true)
        )
        #else
        content.overlay {
            ToastHostView(manager: manager)
                .allowsHitTesting(manager.progressOverlay != nil || !manager.toasts.isEmpty)
        }
        #endif
    }
}
