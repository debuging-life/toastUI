//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//

import SwiftUI

public extension View {
    /// Enables toast notifications for this view hierarchy
    /// Apply this to your root view (typically in your App struct)
    func setupToastUI() -> some View {
        modifier(ToastViewModifier())
    }
}
