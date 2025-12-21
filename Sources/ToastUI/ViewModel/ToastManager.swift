//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 28/11/25.
//

import SwiftUI

@MainActor
public class ToastManager: ObservableObject {
    @Published public var toast: ToastModel?
    
    public static let shared = ToastManager()
    
    private init() {}
    
    public func show(_ message: String, type: ToastModel.ToastType = .info, duration: TimeInterval = 3.0) {
        toast = ToastModel(message: message, type: type, duration: duration)
    }
    
    public func showSuccess(_ message: String, duration: TimeInterval = 3.0) {
        show(message, type: .success, duration: duration)
    }
    
    public func showError(_ message: String, duration: TimeInterval = 3.0) {
        show(message, type: .error, duration: duration)
    }
    
    public func showWarning(_ message: String, duration: TimeInterval = 3.0) {
        show(message, type: .warning, duration: duration)
    }
    
    public func showInfo(_ message: String, duration: TimeInterval = 3.0) {
        show(message, type: .info, duration: duration)
    }
    
    public func dismiss() {
        toast = nil
    }
}
