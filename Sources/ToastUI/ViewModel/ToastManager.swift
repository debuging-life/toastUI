//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 28/11/25.
//


import SwiftUI

public class ToastManager: ObservableObject, @unchecked Sendable {
    @Published public var toasts: [ToastMessage] = []
    private var workItems: [UUID: DispatchWorkItem] = [:]
    
    public init() {}
    
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
        showCloseButton: Bool = true
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
                showCloseButton: showCloseButton
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
                icon: icon
            )
        )
    }
    
    // MARK: - Internal Present Logic
    
    @MainActor
    private func presentToast(_ toast: ToastMessage) {
        // For progress toasts, remove any existing progress toasts with same alignment
        if toast.type == .progress {
            let progressToastsToRemove = toasts.filter {
                $0.type == .progress && $0.alignment == toast.alignment
            }
            for progressToast in progressToastsToRemove {
                workItems[progressToast.id]?.cancel()
                workItems.removeValue(forKey: progressToast.id)
            }
            toasts.removeAll {
                $0.type == .progress && $0.alignment == toast.alignment
            }
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            toasts.append(toast)
        }
        
        // Cancel timers for all toasts in this alignment (they're no longer topmost)
        let sameAlignmentToasts = toasts.filter { $0.alignment == toast.alignment }
        for existingToast in sameAlignmentToasts where existingToast.id != toast.id {
            workItems[existingToast.id]?.cancel()
            workItems.removeValue(forKey: existingToast.id)
        }
        
        // Only schedule auto-dismiss for non-progress toasts
        if toast.type != .progress {
            scheduleAutoDismiss(for: toast)
        }
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
        showCloseButton: Bool = true
    ) {
        present(
            title: title,
            message: message,
            type: .success,
            duration: duration,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton
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
        showCloseButton: Bool = true
    ) {
        present(
            title: title,
            message: message,
            type: .error,
            duration: duration,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton
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
        showCloseButton: Bool = true
    ) {
        present(
            title: title,
            message: message,
            type: .warning,
            duration: duration,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton
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
        showCloseButton: Bool = true
    ) {
        present(
            title: title,
            message: message,
            type: .info,
            duration: duration,
            alignment: alignment,
            backgroundColor: backgroundColor,
            configuration: configuration,
            showCloseButton: showCloseButton
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
            showCloseButton: false // Progress toasts never have close button
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
            // Always schedule, don't check if workItem exists
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
}
