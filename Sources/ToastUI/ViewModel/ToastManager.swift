//
//  ToastManager.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 28/11/25.
//

import SwiftUI

@MainActor
public class ToastManager: ObservableObject {
    @Published public var toasts: [ToastMessage] = []
    @Published public var progressOverlay: ProgressOverlayMessage?
    private var workItems: [UUID: DispatchWorkItem] = [:]

    /// Nonisolated so it can be the default for `@Environment(\.toast)`; the
    /// initialiser touches no main-actor state.
    public nonisolated static let shared = ToastManager()

    /// Toasts beyond this are dropped rather than queued forever.
    public var maximumToasts = 5

    /// Whether toasts play haptic feedback as they appear. **Off by default** —
    /// turn it on once, wherever you configure the app:
    ///
    ///     ToastManager.shared.hapticsEnabled = true
    ///
    /// A single toast can override this either way with `ToastMessage.playsHaptic`.
    public var hapticsEnabled = false

    /// Override ToastUI's haptics with your own. Tests set this to observe them.
    public var haptics: (@MainActor (ToastType) -> Void)?

    public nonisolated init() {}
    
    // MARK: - Main Present Method
    
    @MainActor
    public func present(
        title: String,
        message: String? = nil,
        type: ToastType,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false
    ) {
        presentToast(
            ToastMessage(
                title: title,
                message: message,
                type: type,
                duration: duration,
                alignment: alignment,
                backgroundColor: backgroundColor,
                configuration: configuration,
                showCloseButton: showCloseButton,
                enableCopy: enableCopy
            )
        )
    }
    
    // MARK: - Present with Custom Icon
    
    @MainActor
    public func present<Icon: View>(
        title: String,
        message: String? = nil,
        type: ToastType,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false,
        @ViewBuilder icon: () -> Icon
    ) {
        presentToast(
            ToastMessage(
                title: title,
                message: message,
                type: type,
                duration: duration,
                alignment: alignment,
                backgroundColor: backgroundColor,
                configuration: configuration,
                showCloseButton: showCloseButton,
                enableCopy: enableCopy,
                icon: icon
            )
        )
    }
    
    // MARK: - Internal Present Logic
    
    /// Presents a prepared message. Everything else here funnels into this.
    @MainActor
    public func present(_ toast: ToastMessage) {
        presentToast(toast)
    }

    @MainActor
    private func presentToast(_ toast: ToastMessage) {
        // A grouped toast replaces the one already on screen rather than stacking:
        // "GPS signal lost" ten times in a run should still be one toast.
        if let group = toast.groupID,
           let existing = toasts.firstIndex(where: { $0.groupID == group }) {
            let replacedID = toasts[existing].id
            workItems[replacedID]?.cancel()
            workItems.removeValue(forKey: replacedID)
            toasts[existing] = toast
            AccessibilityAnnouncer.announce(toast.accessibilityText)
            playHaptics(for: toast)
            scheduleAutoDismiss(for: toast)
            return
        }

        // For progress toasts, check if one already exists for this alignment
        if toast.type == .progress {
            if let existingIndex = toasts.firstIndex(where: { $0.type == .progress && $0.alignment == toast.alignment }) {
                // Update existing progress toast WITHOUT animation
                var updatedToast = toasts[existingIndex]
                updatedToast.updateTitle(toast.title)
                toasts[existingIndex] = updatedToast
                return // Don't create a new toast
            } else {
                // No existing progress toast, create new one (with animation)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    toasts.append(toast)
                }
                return // Progress toasts don't have timers
            }
        }
        
        // For non-progress toasts, add with animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            toasts.append(toast)
            // Keep the stack bounded. The least important, oldest toast makes way,
            // so a failure isn't pushed off screen by a run of info messages.
            while toasts.filter({ $0.alignment == toast.alignment }).count > maximumToasts {
                let candidates = toasts.filter { $0.alignment == toast.alignment && $0.id != toast.id }
                guard let evicted = candidates.min(by: { lhs, rhs in
                    lhs.type.priority != rhs.type.priority
                        ? lhs.type.priority < rhs.type.priority
                        : (toasts.firstIndex(of: lhs) ?? 0) < (toasts.firstIndex(of: rhs) ?? 0)
                }) else { break }
                workItems[evicted.id]?.cancel()
                workItems.removeValue(forKey: evicted.id)
                toasts.removeAll { $0.id == evicted.id }
            }
        }
        
        // Cancel timers for all toasts in this alignment (they're no longer topmost)
        let sameAlignmentToasts = toasts.filter { $0.alignment == toast.alignment }
        for existingToast in sameAlignmentToasts where existingToast.id != toast.id {
            workItems[existingToast.id]?.cancel()
            workItems.removeValue(forKey: existingToast.id)
        }
        
        AccessibilityAnnouncer.announce(toast.accessibilityText)
        playHaptics(for: toast)

        // Schedule auto-dismiss for non-progress toasts
        scheduleAutoDismiss(for: toast)
    }
    
    @MainActor
    private func scheduleAutoDismiss(for toast: ToastMessage) {
        // Cancel any existing timer for this toast
        workItems[toast.id]?.cancel()
        
        let task = DispatchWorkItem { [weak self, toastId = toast.id] in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.dismiss(id: toastId)
            }
        }
        
        // A sticky toast waits for the user. `.infinity` (or anything absurd) would
        // trap DispatchTime maths, so it is treated the same way.
        guard !toast.isSticky, toast.duration.isFinite, toast.duration > 0, toast.duration < 60 * 60 else { return }
        workItems[toast.id] = task
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
    
    // MARK: - Convenience Methods
    
    @MainActor
    public func success(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false
    ) {
        present(
            title: title,
            message: message,
            type: .success,
            duration: duration,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton,
            enableCopy: enableCopy
        )
    }
    
    @MainActor
    public func error(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false
    ) {
        present(
            title: title,
            message: message,
            type: .error,
            duration: duration,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton,
            enableCopy: enableCopy
        )
    }
    
    @MainActor
    public func warning(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false
    ) {
        present(
            title: title,
            message: message,
            type: .warning,
            duration: duration,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton,
            enableCopy: enableCopy
        )
    }
    
    @MainActor
    public func info(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false
    ) {
        present(
            title: title,
            message: message,
            type: .info,
            duration: duration,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton,
            enableCopy: enableCopy
        )
    }
    
    @MainActor
    public func progress(
        title: String,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil,
        configuration: ToastConfiguration = .default
    ) {
        present(
            title: title,
            message: nil,
            type: .progress,
            duration: .infinity,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: false,
            enableCopy: false
        )
    }

    @MainActor
    public func glass(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        configuration: ToastConfiguration = .default,
        showCloseButton: Bool = true,
        enableCopy: Bool = false
    ) {
        // Glass effect with automatic fallback based on iOS version
        present(
            title: title,
            message: message,
            type: .glass,
            duration: duration,
            alignment: alignment,
            backgroundColor: nil,
            configuration: configuration,
            showCloseButton: showCloseButton,
            enableCopy: enableCopy
        )
    }
    
    // MARK: - Dismiss Methods
    
    @MainActor
    public func dismiss(id: UUID) {
        // Cancel the work item for this toast
        workItems[id]?.cancel()
        workItems.removeValue(forKey: id)
        
        // Find the alignment of the toast being dismissed
        let dismissedToast = toasts.first(where: { $0.id == id })
        let alignment = dismissedToast?.alignment
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            toasts.removeAll { $0.id == id }
        }
        
        // Schedule the new top toast in this alignment (if exists and not progress)
        if let alignment = alignment,
           let newTopToast = toasts.filter({ $0.alignment == alignment }).last,
           newTopToast.type != .progress {
            scheduleAutoDismiss(for: newTopToast)
        }
    }
    
    @MainActor
    public func dismissAll() {
        workItems.values.forEach { $0.cancel() }
        workItems.removeAll()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            toasts.removeAll()
        }
    }
    
    // Legacy support - dismisses the last (topmost) toast
    @MainActor
    public func dismiss() {
        if let last = toasts.last {
            dismiss(id: last.id)
        }
    }

    // MARK: - Haptics

    private func playHaptics(for toast: ToastMessage) {
        // The toast decides when it says so; otherwise the app-wide setting does.
        guard toast.playsHaptic ?? hapticsEnabled else { return }
        (haptics ?? Self.defaultHaptics)(toast.type)
    }

    static let defaultHaptics: @MainActor (ToastType) -> Void = { type in
        #if os(iOS)
        switch type {
        case .success: UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .error: UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .warning: UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .info, .progress, .glass: break
        }
        #endif
    }

    // MARK: - Progress Overlay Methods

    /// Show progress overlay with default spinner
    /// - Parameters:
    ///   - progress: 0...1 for a determinate ring; nil keeps the spinner.
    ///   - onCancel: shows a Cancel button, for uploads and long syncs.
    @MainActor
    public func showProgressOverlay(
        title: String? = nil,
        message: String? = nil,
        position: ProgressOverlayPosition = .center,
        configuration: ProgressOverlayConfiguration = .default,
        dismissible: Bool = false,
        progress: Double? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        let overlay = ProgressOverlayMessage(
            title: title,
            message: message,
            position: position,
            configuration: configuration,
            dismissible: dismissible,
            progress: progress,
            onCancel: onCancel,
            onDismiss: { [weak self] in
                self?.dismissProgressOverlay()
            }
        )
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            progressOverlay = overlay
        }
        AccessibilityAnnouncer.announce([title, message].compactMap { $0 }.joined(separator: ". "))
    }

    /// Show progress overlay with custom view
    @MainActor
    public func showProgressOverlay<Content: View>(
        title: String? = nil,
        message: String? = nil,
        position: ProgressOverlayPosition = .center,
        configuration: ProgressOverlayConfiguration = .default,
        dismissible: Bool = false,
        progress: Double? = nil,
        onCancel: (() -> Void)? = nil,
        @ViewBuilder customView: () -> Content
    ) {
        let overlay = ProgressOverlayMessage(
            title: title,
            message: message,
            position: position,
            configuration: configuration,
            customView: AnyView(customView()),
            dismissible: dismissible,
            progress: progress,
            onCancel: onCancel,
            onDismiss: { [weak self] in
                self?.dismissProgressOverlay()
            }
        )
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            progressOverlay = overlay
        }
    }

    /// Updates the overlay that is already on screen, without re-animating it —
    /// the way an upload reports 0%, 12%, 40%… Does nothing when none is showing.
    @MainActor
    public func updateProgressOverlay(progress: Double? = nil,
                                      title: String? = nil,
                                      message: String? = nil) {
        guard var overlay = progressOverlay else { return }
        if let progress { overlay.progress = min(max(progress, 0), 1) }
        if let title { overlay.title = title }
        if let message { overlay.message = message }
        progressOverlay = overlay   // no withAnimation: the panel must not bounce on every tick
    }

    /// Dismiss progress overlay
    @MainActor
    public func dismissProgressOverlay() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            progressOverlay = nil
        }
    }

    /// Check if progress overlay is showing
    public var isProgressOverlayShowing: Bool {
        progressOverlay != nil
    }
}
