//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 22/12/25.
//


import SwiftUI

public struct DialogConfiguration: Sendable {
    public let backgroundColor: Color
    public let cornerRadius: CGFloat
    public let shadowRadius: CGFloat
    public let maxWidth: CGFloat
    public let horizontalPadding: CGFloat
    public let dismissOnBackgroundTap: Bool
    public let animationDuration: Double
    
    public init(
        backgroundColor: Color = .black.opacity(0.25),
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 20,
        maxWidth: CGFloat = 500,
        horizontalPadding: CGFloat = 24,
        dismissOnBackgroundTap: Bool = true,
        animationDuration: Double = 0.4
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.maxWidth = maxWidth
        self.horizontalPadding = horizontalPadding
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.animationDuration = animationDuration
    }
    
    public static let `default` = DialogConfiguration()
    
    public static let compact = DialogConfiguration(
        maxWidth: 400,
        horizontalPadding: 16
    )
    
    public static let wide = DialogConfiguration(
        maxWidth: 600,
        horizontalPadding: 32
    )
}
