//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 28/11/25.
//

import SwiftUI

public struct ToastModifier: ViewModifier {
    @Binding var toast: ToastModel?
    
    public init(toast: Binding<ToastModel?>) {
        self._toast = toast
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: overlayAlignment) {
                content

                if let toast = toast {
                    ToastView(toast: toast)
                        .transition(transitionForAlignment(toast.alignment))
                        .padding(paddingForAlignment(toast.alignment))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                                withAnimation {
                                    self.toast = nil
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.spring(), value: toast)
    }
    
    private var overlayAlignment: Alignment {
        guard let toast = toast else { return .top }
        
        switch toast.alignment {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .center:
            return .center
        }
    }
    
    private func transitionForAlignment(_ alignment: ToastModel.ToastAlignment) -> AnyTransition {
        switch alignment {
        case .top:
            return .move(edge: .top).combined(with: .opacity)
        case .bottom:
            return .move(edge: .bottom).combined(with: .opacity)
        case .center:
            return .scale.combined(with: .opacity)
        }
    }
    
    private func paddingForAlignment(_ alignment: ToastModel.ToastAlignment) -> EdgeInsets {
        switch alignment {
        case .top:
            return EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0)
        case .bottom:
            return EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0)
        case .center:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }
}

public extension View {
    func toast(_ toast: Binding<ToastModel?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}
