//
//  ToastHostView.swift
//  ToastUI
//

import SwiftUI

/// Everything ToastUI draws on top of your app: the three toast stacks and the
/// loading overlay. Hosted in a pass-through window on iOS, and as a plain overlay
/// on macOS and watchOS, which have no second window to spare.
struct ToastHostView: View {
    @ObservedObject var manager: ToastManager
    /// Called with the on-screen rectangle of every visible toast. The iOS window
    /// needs them for hit-testing; other platforms pass nil.
    var onFramesChange: (([UUID: CGRect]) -> Void)?

    /// Which stacks the user has fanned out into a list.
    @State private var expanded: Set<ToastAlignment> = []

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                stack(for: .top)
                Spacer(minLength: 0)
                stack(for: .center)
                Spacer(minLength: 0)
                stack(for: .bottom)
            }

            if let request = manager.dialog {
                ZStack {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .contentShape(.rect)
                        .onTapGesture { request.respond(false) }

                    AlertDialog(
                        title: request.title,
                        message: request.message ?? "",
                        primaryButton: DialogButton(
                            title: request.confirmTitle,
                            style: request.isDestructive ? .destructive : .primary
                        ) { request.respond(true) },
                        secondaryButton: request.cancelTitle.map { title in
                            DialogButton(title: title, style: .cancel) { request.respond(false) }
                        }
                    )
                    .padding(24)
                    .frame(maxWidth: 420)
                    .background(.background, in: .rect(cornerRadius: 20, style: .continuous))
                    .padding(24)
                    .accessibilityAddTraits(.isModal)
                }
                .transition(.opacity)
                .zIndex(1000)
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
        .onChange(of: manager.toasts.map(\.id)) { _, ids in
            onFramesChange?([:])
            // A stack with nothing left in it stops being expanded.
            for alignment in expanded where !manager.toasts.contains(where: { $0.alignment == alignment }) {
                expanded.remove(alignment)
            }
            if ids.isEmpty { manager.setAutoDismissPaused(false) }
        }
    }

    // MARK: - Toast stacks

    @ViewBuilder
    private func stack(for alignment: ToastAlignment) -> some View {
        let toasts = manager.toasts.filter { $0.alignment == alignment }
        let isExpanded = expanded.contains(alignment)
        // Newest first when fanned out, so the thing that just happened is on top.
        let ordered = isExpanded && alignment != .bottom ? toasts.reversed().map { $0 } : toasts

        VStack(spacing: isExpanded ? 8 : 0) {
            if isExpanded, toasts.count > 1 {
                stackControls(for: alignment, count: toasts.count)
            }

            ZStack {
                ForEach(Array(ordered.enumerated()), id: \.element.id) { index, toast in
                    toastRow(toast, index: index, total: ordered.count, alignment: alignment, isExpanded: isExpanded)
                }
            }
            .modifier(ExpandedLayout(isExpanded: isExpanded, spacing: 8))
        }
        .padding(alignment == .top ? .top : .bottom, toasts.isEmpty || alignment == .center ? 0 : 8)
        .frame(maxHeight: toasts.isEmpty ? 0 : nil)
        .animation(manager.theme.animation, value: toasts.map(\.id))
        .animation(manager.theme.animation, value: isExpanded)
        .onPreferenceChange(ToastFramePreferenceKey.self) { frames in
            onFramesChange?(frames)
        }
    }

    @ViewBuilder
    private func toastRow(_ toast: ToastMessage,
                          index: Int,
                          total: Int,
                          alignment: ToastAlignment,
                          isExpanded: Bool) -> some View {
        ToastView(
            toast: toast,
            theme: manager.theme,
            isCountingDown: !isExpanded && !manager.isAutoDismissPaused,
            onDismiss: { manager.dismiss(id: toast.id, reason: .userTapped) }
        )
        .scaleEffect(isExpanded ? 1 : scale(for: index, total: total))
        .offset(y: isExpanded ? 0 : stackOffset(for: index, total: total, alignment: alignment))
        .opacity(isExpanded ? 1 : opacity(for: index, total: total))
        .zIndex(Double(index))
        .transition(transition(for: alignment))
        .background(frameReporter(for: toast))
        // Tapping a collapsed stack of more than one fans it out instead of dismissing.
        .simultaneousGesture(TapGesture().onEnded {
            guard !isExpanded, total > 1 else { return }
            expand(alignment, count: total)
        })
        .allowsHitTesting(isExpanded || index == total - 1)
    }

    @ViewBuilder
    private func stackControls(for alignment: ToastAlignment, count: Int) -> some View {
        HStack {
            Button {
                collapse(alignment)
            } label: {
                Label(L10n.collapse, systemImage: "chevron.up")
                    .labelStyle(.titleAndIcon)
                    .font(.caption.weight(.semibold))
            }

            Spacer()

            Button(L10n.clearAll) {
                collapse(alignment)
                for toast in manager.toasts where toast.alignment == alignment {
                    manager.dismiss(id: toast.id, reason: .userTapped)
                }
            }
            .font(.caption.weight(.semibold))
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 4)
        .foregroundStyle(.secondary)
        .accessibilityHint(L10n.notificationCount(count))
    }

    private func expand(_ alignment: ToastAlignment, count: Int) {
        expanded.insert(alignment)
        manager.setAutoDismissPaused(true)   // nothing vanishes while the list is open
        manager.onEvent?(.stackExpanded(count: count))
        AccessibilityAnnouncer.announce(L10n.notificationCount(count))
    }

    private func collapse(_ alignment: ToastAlignment) {
        expanded.remove(alignment)
        if expanded.isEmpty { manager.setAutoDismissPaused(false) }
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

    // MARK: - Loading overlay

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

    // MARK: - Collapsed stacking maths (only the top three are visible)

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

/// Collapsed toasts sit on top of each other in a ZStack; expanded ones become a
/// scrollable list. Swapping the container keeps both layouts in one place.
private struct ExpandedLayout: ViewModifier {
    let isExpanded: Bool
    let spacing: CGFloat

    func body(content: Content) -> some View {
        if isExpanded {
            ScrollView {
                VStack(spacing: spacing) { content }
            }
            .scrollIndicators(.hidden)
            .frame(maxHeight: 420)
        } else {
            content
        }
    }
}

// MARK: - Preference key

struct ToastFramePreferenceKey: PreferenceKey {
    static let defaultValue: [UUID: CGRect] = [:]

    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}
