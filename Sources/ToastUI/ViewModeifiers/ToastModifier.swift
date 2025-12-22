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
            
            // Toast container - ALWAYS present
            VStack(spacing: 0) {
                // Top toasts section - ALWAYS present
                topToastsSection
                
                Spacer(minLength: 0)
                
                // Center toasts section - ALWAYS present
                centerToastsSection
                
                Spacer(minLength: 0)
                
                // Bottom toasts section - ALWAYS present
                bottomToastsSection
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(999)
        }
        .environment(\.toast, toastManager)
    }
    
    @ViewBuilder
    private var topToastsSection: some View {
        let topToasts = toastManager.toasts.filter { $0.alignment == .top }
        
        ZStack {
            ForEach(Array(topToasts.enumerated()), id: \.element.id) { index, toast in
                toastView(toast)
                    .scaleEffect(calculateScale(for: index, total: topToasts.count))
                    .offset(y: calculateStackOffset(for: index, total: topToasts.count, alignment: .top))
                    .opacity(calculateOpacity(for: index, total: topToasts.count))
                    .zIndex(Double(index))
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        )
                    )
            }
        }
        .padding(.top, topToasts.isEmpty ? 0 : 8)
        .frame(maxHeight: topToasts.isEmpty ? 0 : nil)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: topToasts.map { $0.id })
    }
    
    @ViewBuilder
    private var centerToastsSection: some View {
        let centerToasts = toastManager.toasts.filter { $0.alignment == .center }
        
        ZStack {
            ForEach(Array(centerToasts.enumerated()), id: \.element.id) { index, toast in
                toastView(toast)
                    .scaleEffect(calculateScale(for: index, total: centerToasts.count))
                    .opacity(calculateOpacity(for: index, total: centerToasts.count))
                    .zIndex(Double(index))
                    .transition(
                        .scale(scale: 0.8).combined(with: .opacity)
                    )
            }
        }
        .frame(maxHeight: centerToasts.isEmpty ? 0 : nil)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: centerToasts.map { $0.id })
    }
    
    @ViewBuilder
    private var bottomToastsSection: some View {
        let bottomToasts = toastManager.toasts.filter { $0.alignment == .bottom }
        
        ZStack {
            ForEach(Array(bottomToasts.enumerated()), id: \.element.id) { index, toast in
                toastView(toast)
                    .scaleEffect(calculateScale(for: index, total: bottomToasts.count))
                    .offset(y: calculateStackOffset(for: index, total: bottomToasts.count, alignment: .bottom))
                    .opacity(calculateOpacity(for: index, total: bottomToasts.count))
                    .zIndex(Double(index))
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        )
                    )
            }
        }
        .padding(.bottom, bottomToasts.isEmpty ? 0 : 8)
        .frame(maxHeight: bottomToasts.isEmpty ? 0 : nil)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: bottomToasts.map { $0.id })
    }
    
    @ViewBuilder
    private func toastView(_ toast: ToastMessage) -> some View {
        ToastView(toast: toast) {
            toastManager.dismiss(id: toast.id)
        }
    }
    
    // MARK: - Stack Calculations
    
    private func calculateScale(for index: Int, total: Int) -> CGFloat {
        let maxVisible = 3
        let position = total - 1 - index
        
        if position >= maxVisible {
            return 0.85 // Hidden toasts
        }
        
        // Scale: 1.0 (top), 0.95, 0.90
        return 1.0 - (CGFloat(position) * 0.05)
    }
    
    private func calculateStackOffset(for index: Int, total: Int, alignment: ToastAlignment) -> CGFloat {
        let maxVisible = 3
        let position = total - 1 - index
        
        if position >= maxVisible {
            return 0 // Hidden toasts stay at base position
        }
        
        // Offset: 0 (top), 8, 16
        let offset = CGFloat(position) * 8
        return alignment == .bottom ? -offset : offset
    }
    
    private func calculateOpacity(for index: Int, total: Int) -> Double {
        let maxVisible = 3
        let position = total - 1 - index
        
        if position >= maxVisible {
            return 0 // Hide toasts beyond the 3rd
        }
        
        return 1.0
    }
}

// MARK: - Preference Key for Toast Heights
struct ToastHeightPreferenceKey: PreferenceKey {
    static let defaultValue: [UUID: CGFloat] = [:]
    
    static func reduce(value: inout [UUID: CGFloat], nextValue: () -> [UUID: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
