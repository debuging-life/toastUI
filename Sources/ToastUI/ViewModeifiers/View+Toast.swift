//
//  View+Toast.swift
//  ToastUI
//

import SwiftUI

public extension View {
    /// Enables toast notifications for this view hierarchy.
    /// Apply this once, to your root view.
    ///
    /// On iOS the toasts live in their own pass-through window, so they appear above
    /// sheets and covers. Elsewhere they are an overlay on this view.
    func setupToastUI(manager: ToastManager = .shared) -> some View {
        modifier(ToastSetupModifier(manager: manager))
    }
}

private struct ToastSetupModifier: ViewModifier {
    @ObservedObject var manager: ToastManager

    func body(content: Content) -> some View {
        #if os(iOS)
        content.task {
            ToastWindowManager.shared.setup(with: manager)
        }
        #else
        content.overlay {
            ToastHostView(manager: manager)
                .allowsHitTesting(manager.progressOverlay != nil || !manager.toasts.isEmpty)
        }
        #endif
    }
}
