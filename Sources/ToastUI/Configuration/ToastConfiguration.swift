//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//

import SwiftUI

public struct ToastConfiguration : Sendable {
    public let cornerRadius: CGFloat
    public let shadowRadius: CGFloat
    public let shadowColor: Color
    public let shadowX: CGFloat
    public let shadowY: CGFloat
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    
    public init(
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 10,
        shadowColor: Color = .black.opacity(0.2),
        shadowX: CGFloat = 0,
        shadowY: CGFloat = 5,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 16
    ) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
    
    public static let `default` = ToastConfiguration()
    
    public static let compact = ToastConfiguration(
        cornerRadius: 8,
        shadowRadius: 5,
        shadowY: 3,
        horizontalPadding: 12,
        verticalPadding: 12
    )
    
    public static let rounded = ToastConfiguration(
        cornerRadius: 20,
        shadowRadius: 15,
        shadowY: 8
    )
    
    public static let minimal = ToastConfiguration(
        cornerRadius: 6,
        shadowRadius: 3,
        shadowY: 2,
        horizontalPadding: 12,
        verticalPadding: 10
    )
}
