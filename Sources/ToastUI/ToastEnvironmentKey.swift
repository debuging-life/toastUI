//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//


import SwiftUI

private struct ToastEnvironmentKey: EnvironmentKey {
    static let defaultValue = ToastManager()
}

public extension EnvironmentValues {
    var toast: ToastManager {
        get { self[ToastEnvironmentKey.self] }
        set { self[ToastEnvironmentKey.self] = newValue }
    }
}
