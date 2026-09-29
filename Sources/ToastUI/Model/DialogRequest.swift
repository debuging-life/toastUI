//
//  DialogRequest.swift
//  ToastUI
//

import SwiftUI

/// A dialog the manager is showing and waiting on. Created by `confirm` / `alert`.
public struct DialogRequest: Identifiable, Equatable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let confirmTitle: String
    public let cancelTitle: String?
    public let isDestructive: Bool
    /// Resumes whoever is awaiting the answer. Called exactly once.
    let respond: @MainActor (Bool) -> Void

    public static func == (lhs: DialogRequest, rhs: DialogRequest) -> Bool { lhs.id == rhs.id }
}
