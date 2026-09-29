//
//  ToastWindowManager.swift
//  ToastUI
//

import SwiftUI

#if os(iOS) || os(tvOS)   // watchOS and macOS have no UIWindow; they use the overlay host
import UIKit

/// Puts the toast host in its own window per scene, so toasts appear above sheets and
/// covers — and, on iPad or Stage Manager, in the window the user is actually looking
/// at rather than whichever scene happened to connect first.
@MainActor
final class ToastWindowManager {
    static let shared = ToastWindowManager()

    private var windows: [String: ToastPassThroughWindow] = [:]

    private init() {}

    func setup(with manager: ToastManager, in scene: UIWindowScene) {
        pruneDisconnectedScenes()

        let id = scene.session.persistentIdentifier
        guard windows[id] == nil else { return }

        let window = ToastPassThroughWindow(windowScene: scene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear

        let hosting = UIHostingController(
            rootView: ToastHostView(manager: manager) { [weak window] frames in
                guard let window else { return }
                // Keep only frames for toasts still on screen; stale rectangles would
                // swallow taps where a toast used to be.
                let live = Set(manager.toasts.map(\.id))
                window.toastFrames = window.toastFrames
                    .merging(frames) { _, new in new }
                    .filter { live.contains($0.key) }
                window.isBlocking = manager.progressOverlay?.configuration.isBlocking ?? false
                    || manager.isStackExpanded
            }
        )
        hosting.view.backgroundColor = .clear
        window.rootViewController = hosting
        window.isHidden = false

        windows[id] = window
    }

    /// Drops windows whose scene has gone away — a closed iPad window, say. Checked
    /// when a scene appears rather than observed, which keeps it free of the data-race
    /// problems that come with notifications.
    private func pruneDisconnectedScenes() {
        let live = Set(UIApplication.shared.connectedScenes.map(\.session.persistentIdentifier))
        for (id, window) in windows where !live.contains(id) {
            window.isHidden = true
            windows.removeValue(forKey: id)
        }
    }
}

/// Passes touches through to the app, except where a toast actually is — or anywhere
/// at all while a blocking loading overlay is up.
final class ToastPassThroughWindow: UIWindow {
    var toastFrames: [UUID: CGRect] = [:]
    var isBlocking = false

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        if isBlocking { return hitView }
        let touchIsOnToast = toastFrames.values.contains { $0.contains(point) }
        return touchIsOnToast ? hitView : nil
    }
}

/// Finds the window scene this view belongs to, so the toast window lands in the
/// right one when the app has several.
struct ToastSceneReader: UIViewRepresentable {
    let onScene: (UIWindowScene) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async { report(from: view) }
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        report(from: view)
    }

    private func report(from view: UIView) {
        guard let scene = view.window?.windowScene else { return }
        onScene(scene)
    }
}
#endif
