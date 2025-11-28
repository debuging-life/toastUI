//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 28/11/25.
//

import SwiftUI

public struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    
    public init(toast: Binding<Toast?>) {
        self._toast = toast
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast = toast {
                    ToastView(toast: toast)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                                withAnimation {
                                    self.toast = nil
                                }
                            }
                        }
                        .padding(.top, 50)
                }
            }
            .animation(.spring(), value: toast)
    }
}

public extension View {
    func toast(_ toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}
