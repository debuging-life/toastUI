//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 21/12/25.
//


import SwiftUI

public enum ToastAlignment {
    case top
    case center
    case bottom
    
    var swiftUIAlignment: Alignment {
        switch self {
        case .top: return .top
        case .center: return .center
        case .bottom: return .bottom
        }
    }
    
    var edge: Edge {
        switch self {
        case .top: return .top
        case .center: return .top
        case .bottom: return .bottom
        }
    }
}
