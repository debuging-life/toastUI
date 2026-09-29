//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 23/12/25.
//


import SwiftUI

#if canImport(UIKit)
import UIKit

@MainActor
class ToastWindowManager: ObservableObject {
    static let shared = ToastWindowManager()

    private var toastWindow: UIWindow?
    private var isSetup = false
    @Published var toastFrames: [UUID: CGRect] = [:] // Track toast positions
    /// While a blocking progress overlay is up, the whole window takes touches.
    @Published var isBlocking = false

    private init() {}

    /// Drops frames for toasts that are gone. Without this their rectangles keep
    /// swallowing touches, leaving dead zones on screen.
    func pruneFrames(keeping ids: Set<UUID>) {
        guard !toastFrames.isEmpty else { return }
        toastFrames = toastFrames.filter { ids.contains($0.key) }
    }

    func setup(with manager: ToastManager) {
        guard !isSetup else {
            return
        }

        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else {
            return
        }


        let window = ToastPassThroughWindow(windowScene: windowScene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        window.toastWindowManager = self

        let hostingController = UIHostingController(
            rootView: ToastWindowRootView(manager: manager, windowManager: self)
        )
        hostingController.view.backgroundColor = .clear

        window.rootViewController = hostingController
        window.isHidden = false

        self.toastWindow = window
        self.isSetup = true

    }
}

// MARK: - Smart PassThrough Window

@MainActor
class ToastPassThroughWindow: UIWindow {
    weak var toastWindowManager: ToastWindowManager?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else {
            return nil
        }

        // Check if touch is within any toast frame
        // A blocking overlay must swallow everything, not just its own rectangle.
        if toastWindowManager?.isBlocking == true {
            return hitView
        }

        let touchIsOnToast = toastWindowManager?.toastFrames.values.contains(where: { frame in
            frame.contains(point)
        }) ?? false

        if touchIsOnToast {
            // Touch is on a toast, handle it normally
            return hitView
        } else {
            // Touch is not on any toast, pass through to underlying window
            return nil
        }
    }
}
#endif
