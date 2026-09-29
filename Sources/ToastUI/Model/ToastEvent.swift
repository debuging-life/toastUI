//
//  ToastEvent.swift
//  ToastUI
//

import Foundation

/// Reported through `ToastManager.onEvent`, so apps can answer questions like
/// "does anyone actually tap Undo?" without changing this package.
public enum ToastEvent: Sendable {
    case shown(id: UUID, title: String, type: ToastType)
    case dismissed(id: UUID, reason: DismissReason)
    case actionTapped(id: UUID, title: String)
    case stackExpanded(count: Int)
    case loadingShown(title: String?)
    case loadingCancelled(title: String?)
    case loadingDismissed(title: String?)

    public enum DismissReason: Sendable {
        case timeout
        case userTapped
        case userSwiped
        case replaced
        case programmatic
    }
}
