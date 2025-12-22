//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 28/11/25.
//
//
//  ToastViewModifier.swift
//  ToastPackage
//

import SwiftUI

struct ToastViewModifier: ViewModifier {
    @StateObject private var toastManager = ToastManager()
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            toastOverlay
        }
        .environment(\.toast, toastManager)
    }
    
    @ViewBuilder
    private var toastOverlay: some View {
        if let toast = toastManager.currentToast {
            VStack(spacing: 0) {
                if toast.alignment == .top {
                    toastView(toast)
                        .padding(.top, 8)
                    Spacer(minLength: 0)
                } else if toast.alignment == .center {
                    Spacer(minLength: 0)
                    toastView(toast)
                    Spacer(minLength: 0)
                } else { 
                    Spacer(minLength: 0)
                    toastView(toast)
                        .padding(.bottom, 8)
                }
            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: toast.alignment.edge).combined(with: .opacity),
                    removal: .move(edge: toast.alignment.edge).combined(with: .opacity)
                )
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: toastManager.currentToast?.id)
            .zIndex(999)
        }
    }
    
    @ViewBuilder
    private func toastView(_ toast: ToastMessage) -> some View {
        ToastView(toast: toast) {
            toastManager.dismiss()
        }
    }
}
