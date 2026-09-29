//
//  ToastHostView.swift
//  ToastUI
//

import SwiftUI

/// Everything ToastUI draws on top of your app: the three toast stacks and the
/// progress overlay. Hosted in a pass-through window on iOS, and as a plain
/// overlay on macOS and watchOS, which have no second window to spare.
struct ToastHostView: View {
    @ObservedObject var manager: ToastManager
    /// Called with the on-screen rectangle of every visible toast. The iOS window
    /// needs them for hit-testing; other platforms pass nil.
    var onFramesChange: (([UUID: CGRect]) -> Void)?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                stack(for: .top)
                Spacer(minLength: 0)
                stack(for: .center)
                Spacer(minLength: 0)
                stack(for: .bottom)
            }

            if let overlay = manager.progressOverlay {
                ZStack {
                    if overlay.configuration.isBlocking {
                        Color.black
                            .opacity(overlay.configuration.backdropOpacity)
                            .ignoresSafeArea()
                            .contentShape(.rect)
                            .onTapGesture { }   // swallow taps on the app underneath
                            .accessibilityHidden(true)
                    }
                    overlayContent(for: overlay)
                }
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: manager.toasts.map(\.id)) { _, _ in
            report()
        }
    }

    // MARK: - Toast stacks

    @ViewBuilder
    private func stack(for alignment: ToastAlignment) -> some View {
        let toasts = manager.toasts.filter { $0.alignment == alignment }

        ZStack {
            ForEach(Array(toasts.enumerated()), id: \.element.id) { index, toast in
                ToastView(toast: toast) { manager.dismiss(id: toast.id) }
                    .scaleEffect(scale(for: index, total: toasts.count))
                    .offset(y: stackOffset(for: index, total: toasts.count, alignment: alignment))
                    .opacity(opacity(for: index, total: toasts.count))
                    .zIndex(Double(index))
                    .transition(transition(for: alignment))
                    .background(frameReporter(for: toast))
            }
        }
        .padding(alignment == .top ? .top : .bottom, toasts.isEmpty || alignment == .center ? 0 : 8)
        .frame(maxHeight: toasts.isEmpty ? 0 : nil)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: toasts.map(\.id))
        .onPreferenceChange(ToastFramePreferenceKey.self) { frames in
            onFramesChange?(frames)
        }
    }

    private func transition(for alignment: ToastAlignment) -> AnyTransition {
        switch alignment {
        case .center:
            .scale(scale: 0.8).combined(with: .opacity)
        case .top, .bottom:
            .asymmetric(
                insertion: .move(edge: alignment == .top ? .top : .bottom).combined(with: .opacity),
                removal: .move(edge: alignment == .top ? .top : .bottom).combined(with: .opacity)
            )
        }
    }

    @ViewBuilder
    private func frameReporter(for toast: ToastMessage) -> some View {
        if onFramesChange != nil {
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ToastFramePreferenceKey.self,
                    value: [toast.id: geometry.frame(in: .global)]
                )
            }
        }
    }

    private func report() {
        onFramesChange?([:])   // the window prunes by comparing against live toasts
    }

    // MARK: - Progress overlay

    @ViewBuilder
    private func overlayContent(for overlay: ProgressOverlayMessage) -> some View {
        GeometryReader { geometry in
            ProgressOverlayView(overlay: overlay) { overlay.onDismiss?() }
                .position(position(for: overlay.position, in: geometry.size))
        }
    }

    private func position(for position: ProgressOverlayPosition, in size: CGSize) -> CGPoint {
        switch position {
        case .top: CGPoint(x: size.width / 2, y: size.height * 0.25)
        case .center: CGPoint(x: size.width / 2, y: size.height / 2)
        case .bottom: CGPoint(x: size.width / 2, y: size.height * 0.75)
        case .custom(let x, let y): CGPoint(x: x, y: y)
        }
    }

    // MARK: - Stacking maths (only the top three are visible)

    private func scale(for index: Int, total: Int) -> CGFloat {
        let position = total - 1 - index
        return position >= 3 ? 0.85 : 1.0 - (CGFloat(position) * 0.05)
    }

    private func stackOffset(for index: Int, total: Int, alignment: ToastAlignment) -> CGFloat {
        let position = total - 1 - index
        guard position < 3 else { return 0 }
        let offset = CGFloat(position) * 8
        return alignment == .bottom ? -offset : offset
    }

    private func opacity(for index: Int, total: Int) -> Double {
        (total - 1 - index) >= 3 ? 0 : 1
    }
}

// MARK: - Preference key

struct ToastFramePreferenceKey: PreferenceKey {
    static let defaultValue: [UUID: CGRect] = [:]

    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}
