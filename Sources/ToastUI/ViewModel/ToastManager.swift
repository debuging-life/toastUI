//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 28/11/25.
//
//  ToastManager.swift
//  ToastPackage
//


import SwiftUI

public class ToastManager: ObservableObject, @unchecked Sendable {
    @Published public var currentToast: ToastMessage?
    private var workItem: DispatchWorkItem?
    
    public init() {}
    
    // MARK: - Main Present Method
    
    @MainActor
    public func present(
        title: String,
        message: String? = nil,
        type: ToastType,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil
    ) {
        presentToast(
            ToastMessage(
                title: title,
                message: message,
                type: type,
                duration: duration,
                alignment: alignment,
                backgroundColor: backgroundColor
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
                icon: icon
            )
        )
    }
    
    // MARK: - Internal Present Logic
    
    @MainActor
    private func presentToast(_ toast: ToastMessage) {
        // Cancel any existing work item
        workItem?.cancel()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentToast = toast
        }
        
        // Auto-dismiss after duration (unless it's progress type)
        if toast.type != .progress {
            let task = DispatchWorkItem { [weak self] in
                Task { @MainActor [weak self] in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        self?.currentToast = nil
                    }
                }
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    // MARK: - Convenience Methods
    
    @MainActor
    public func success(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil
    ) {
        present(title: title, message: message, type: .success, duration: duration, alignment: alignment, backgroundColor: backgroundColor)
    }
    
    @MainActor
    public func error(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil
    ) {
        present(title: title, message: message, type: .error, duration: duration, alignment: alignment, backgroundColor: backgroundColor)
    }
    
    @MainActor
    public func warning(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil
    ) {
        present(title: title, message: message, type: .warning, duration: duration, alignment: alignment, backgroundColor: backgroundColor)
    }
    
    @MainActor
    public func info(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil
    ) {
        present(title: title, message: message, type: .info, duration: duration, alignment: alignment, backgroundColor: backgroundColor)
    }
    
    @MainActor
    public func progress(
        title: String,
        alignment: ToastAlignment = .top,
        backgroundColor: Color? = nil
    ) {
        present(title: title, message: nil, type: .progress, duration: .infinity, alignment: alignment, backgroundColor: backgroundColor)
    }
    
    // MARK: - Dismiss
    
    @MainActor
    public func dismiss() {
        workItem?.cancel()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentToast = nil
        }
    }
}
