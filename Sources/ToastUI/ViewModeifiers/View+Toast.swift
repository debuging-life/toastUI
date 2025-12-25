//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//

import SwiftUI

//public extension View {
//    /// Enables toast notifications for this view hierarchy
//    /// Apply this to your root view (typically in your App struct)
//    func setupToastUI() -> some View {
//        modifier(ToastViewModifier(manager: ToastManager.shared))
//    }
//}



import SwiftUI

public extension View {
    /// Enables toast notifications for this view hierarchy
    /// Apply this to your root view (typically in your App struct)
    func setupToastUI() -> some View {
        modifier(ToastSetupModifier())
    }
}

private struct ToastSetupModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .task {
                #if canImport(UIKit)
                // Small delay to ensure window scene is ready
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                await ToastWindowManager.shared.setup(with: ToastManager.shared)
                #endif
            }
    }
}
