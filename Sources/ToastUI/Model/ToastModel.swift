//
//  File.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 28/11/25.
//

import Foundation


public struct ToastModel: Equatable {
    public let message: String
    public let type: ToastType
    public let duration: TimeInterval
    public let alignment: ToastAlignment
    
    public init(
        message: String,
        type: ToastType,
        duration: TimeInterval = 3,
        alignment: ToastAlignment = .top
    ) {
        self.message = message
        self.type = type
        self.duration = duration
        self.alignment = alignment
    }
}

extension ToastModel {
    public enum ToastType {
        case success
        case error
        case warning
        case info
    }
    
    public enum ToastAlignment {
        case top
        case center
        case bottom
    }
}

