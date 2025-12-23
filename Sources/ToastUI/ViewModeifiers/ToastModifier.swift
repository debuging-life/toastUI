//
//  ToastViewModifier.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 28/11/25.
//


import SwiftUI

struct ToastViewModifier: ViewModifier {
    @ObservedObject var manager: ToastManager
    
    init(manager: ToastManager) {
        self.manager = manager
    }
    
    func body(content: Content) -> some View {
        content
    }
}

// MARK: - Toast Window Root View

struct ToastWindowRootView: View {
    @ObservedObject var manager: ToastManager
    @ObservedObject var windowManager: ToastWindowManager
    
    var body: some View {
        VStack(spacing: 0) {
            topToastsSection
            Spacer(minLength: 0)
            centerToastsSection
            Spacer(minLength: 0)
            bottomToastsSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var topToastsSection: some View {
        let topToasts = manager.toasts.filter { $0.alignment == .top }
        
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
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ToastFramePreferenceKey.self,
                                value: [toast.id: geometry.frame(in: .global)]
                            )
                        }
                    )
            }
        }
        .padding(.top, topToasts.isEmpty ? 0 : 8)
        .frame(maxHeight: topToasts.isEmpty ? 0 : nil)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: topToasts.map { $0.id })
        .onPreferenceChange(ToastFramePreferenceKey.self) { frames in
            windowManager.toastFrames.merge(frames) { _, new in new }
        }
    }
    
    @ViewBuilder
    private var centerToastsSection: some View {
        let centerToasts = manager.toasts.filter { $0.alignment == .center }
        
        ZStack {
            ForEach(Array(centerToasts.enumerated()), id: \.element.id) { index, toast in
                toastView(toast)
                    .scaleEffect(calculateScale(for: index, total: centerToasts.count))
                    .opacity(calculateOpacity(for: index, total: centerToasts.count))
                    .zIndex(Double(index))
                    .transition(
                        .scale(scale: 0.8).combined(with: .opacity)
                    )
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ToastFramePreferenceKey.self,
                                value: [toast.id: geometry.frame(in: .global)]
                            )
                        }
                    )
            }
        }
        .frame(maxHeight: centerToasts.isEmpty ? 0 : nil)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: centerToasts.map { $0.id })
        .onPreferenceChange(ToastFramePreferenceKey.self) { frames in
            windowManager.toastFrames.merge(frames) { _, new in new }
        }
    }
    
    @ViewBuilder
    private var bottomToastsSection: some View {
        let bottomToasts = manager.toasts.filter { $0.alignment == .bottom }
        
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
                    .background(
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ToastFramePreferenceKey.self,
                                value: [toast.id: geometry.frame(in: .global)]
                            )
                        }
                    )
            }
        }
        .padding(.bottom, bottomToasts.isEmpty ? 0 : 8)
        .frame(maxHeight: bottomToasts.isEmpty ? 0 : nil)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: bottomToasts.map { $0.id })
        .onPreferenceChange(ToastFramePreferenceKey.self) { frames in
            windowManager.toastFrames.merge(frames) { _, new in new }
        }
    }
    
    @ViewBuilder
    private func toastView(_ toast: ToastMessage) -> some View {
        ToastView(toast: toast) {
            manager.dismiss(id: toast.id)
        }
    }
    
    // MARK: - Stack Calculations
    
    private func calculateScale(for index: Int, total: Int) -> CGFloat {
        let maxVisible = 3
        let position = total - 1 - index
        
        if position >= maxVisible {
            return 0.85
        }
        return 1.0 - (CGFloat(position) * 0.05)
    }
    
    private func calculateStackOffset(for index: Int, total: Int, alignment: ToastAlignment) -> CGFloat {
        let maxVisible = 3
        let position = total - 1 - index
        
        if position >= maxVisible {
            return 0
        }
        let offset = CGFloat(position) * 8
        return alignment == .bottom ? -offset : offset
    }
    
    private func calculateOpacity(for index: Int, total: Int) -> Double {
        let maxVisible = 3
        let position = total - 1 - index
        
        if position >= maxVisible {
            return 0
        }
        return 1.0
    }
}

// MARK: - Preference Keys

struct ToastFramePreferenceKey: PreferenceKey {
    static let defaultValue: [UUID: CGRect] = [:]
    
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}

struct ToastHeightPreferenceKey: PreferenceKey {
    static let defaultValue: [UUID: CGFloat] = [:]
    
    static func reduce(value: inout [UUID: CGFloat], nextValue: () -> [UUID: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
