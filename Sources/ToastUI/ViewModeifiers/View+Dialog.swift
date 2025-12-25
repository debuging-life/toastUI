//
//  View+Dialog.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 22/12/25.
//

import SwiftUI

#if os(iOS)
public extension View {
    /// Present a custom dialog view
    func dialog<Content: View>(
        config: DialogConfiguration = .default,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            DialogModifier(
                config: config,
                isPresented: isPresented,
                onDismiss: onDismiss,
                viewContent: content
            )
        )
    }
}

fileprivate struct DialogModifier<ViewContent: View>: ViewModifier {
    var config: DialogConfiguration
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)?
    @ViewBuilder var viewContent: ViewContent
    
    @State private var internalPresented: Bool = false
    @State private var showBackdrop: Bool = false
    @State private var showContent: Bool = false
    @State private var isDismissing: Bool = false
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $internalPresented) {
                GeometryReader { geometry in
                    ZStack {
                        // Backdrop - only fades
                        config.backgroundColor
                            .ignoresSafeArea()
                            .opacity(showBackdrop ? 1 : 0)
                            .onTapGesture {
                                if config.dismissOnBackgroundTap {
                                    dismissView()
                                }
                            }
                        
                        // Content - slides from bottom
                        viewContent
                            .frame(maxWidth: config.maxWidth)
                            #if os(iOS)
                            .background(Color(.systemBackground))
                            #else
                            .background(Color(nsColor: .windowBackgroundColor))
                            #endif
                            .cornerRadius(config.cornerRadius)
                            .shadow(
                                color: .black.opacity(0.2),
                                radius: config.shadowRadius,
                                x: 0,
                                y: 10
                            )
                            .padding(.horizontal, config.horizontalPadding)
                            .offset(y: showContent ? 0 : geometry.size.height)
                            .opacity(showContent ? 1 : 0)
                    }
                    #if os(iOS)
                    .background(ClearBackgroundView())
                    #endif
                    .onAppear {
                        // Fade backdrop quickly
                        withAnimation(.easeOut(duration: 0.2)) {
                            showBackdrop = true
                        }
                        
                        // Slide content with delay and bounce
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.bouncy(duration: config.animationDuration, extraBounce: 0.0)) {
                                showContent = true
                            }
                        }
                    }
                    .onDisappear {
                        showBackdrop = false
                        showContent = false
                        isDismissing = false
                        onDismiss?()
                    }
                }
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
            .onChange(of: isPresented) { newValue in
                if newValue {
                    internalPresented = true
                } else if !isDismissing {
                    dismissView()
                }
            }
    }
    
    private func dismissView() {
        guard !isDismissing else { return }
        isDismissing = true
        
        // Fade backdrop
        withAnimation(.easeOut(duration: 0.2)) {
            showBackdrop = false
        }
        
        // Slide content down
        withAnimation(.snappy(duration: config.animationDuration, extraBounce: 0.0)) {
            showContent = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + config.animationDuration) {
            internalPresented = false
            isPresented = false
        }
    }
}

// MARK: - Clear Background Helper (iOS 16 Compatible)

#if os(iOS)
import UIKit

fileprivate struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
#endif
#endif
