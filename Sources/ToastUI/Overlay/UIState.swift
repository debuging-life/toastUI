//
//  UIState.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 24/12/25.
//

import SwiftUI

public enum UIState: Equatable {
    case idle

    case loading(message: String? = nil, loader: AnyView? = nil)

    case empty(message: String = "No data found", icon: AnyView? = nil)

    case failure(message: String, icon: AnyView? = nil)

    case success(message: String, icon: AnyView? = nil)

    case custom(id: String, view: AnyView)

    case rive(id: String, riveName: String, stateMachineName: String? = nil, animationName: String? = nil, title: String? = nil, message: String? = nil)

    public static func == (lhs: UIState, rhs: UIState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case let (.loading(lhsMsg, _), .loading(rhsMsg, _)):
            return lhsMsg == rhsMsg
        case let (.empty(lhsMsg, _), .empty(rhsMsg, _)):
            return lhsMsg == rhsMsg
        case let (.failure(lhsMsg, _), .failure(rhsMsg, _)):
            return lhsMsg == rhsMsg
        case let (.success(lhsMsg, _), .success(rhsMsg, _)):
            return lhsMsg == rhsMsg
        case let (.custom(lhsId, _), .custom(rhsId, _)):
            return lhsId == rhsId
        case let (.rive(lhsId, lhsRive, lhsSM, lhsAnim, lhsTitle, lhsMsg), .rive(rhsId, rhsRive, rhsSM, rhsAnim, rhsTitle, rhsMsg)):
            return lhsId == rhsId && lhsRive == rhsRive && lhsSM == rhsSM && lhsAnim == rhsAnim && lhsTitle == rhsTitle && lhsMsg == rhsMsg
        default:
            return false
        }
    }
}

// MARK: - Convenience Initializers with Custom Icons & Loaders

public extension UIState {
    /// Creates a loading state with a custom loader view
    /// - Parameters:
    ///   - message: Optional message to display below the loader
    ///   - loader: ViewBuilder closure that returns your custom loader view
    static func loading<Loader: View>(message: String? = nil, @ViewBuilder loader: () -> Loader) -> UIState {
        .loading(message: message, loader: AnyView(loader()))
    }

    static func empty<Icon: View>(message: String = "No data found", @ViewBuilder icon: () -> Icon) -> UIState {
        .empty(message: message, icon: AnyView(icon()))
    }

    static func failure<Icon: View>(message: String, @ViewBuilder icon: () -> Icon) -> UIState {
        .failure(message: message, icon: AnyView(icon()))
    }

    static func success<Icon: View>(message: String, @ViewBuilder icon: () -> Icon) -> UIState {
        .success(message: message, icon: AnyView(icon()))
    }
}

// MARK: - Convenience Initializers for Custom Views

public extension UIState {
    /// Creates a custom view state with a unique identifier
    /// - Parameters:
    ///   - id: Unique identifier for this custom state (used for equality comparison)
    ///   - content: ViewBuilder closure that returns your custom view
    static func custom<Content: View>(id: String = UUID().uuidString, @ViewBuilder content: () -> Content) -> UIState {
        .custom(id: id, view: AnyView(content()))
    }

    /// Creates a Rive animation state with optional title and message
    /// - Parameters:
    ///   - id: Unique identifier for this rive state (used for equality comparison)
    ///   - riveName: Name of the .riv file (without extension)
    ///   - stateMachineName: Optional name of the state machine to use
    ///   - animationName: Optional name of the specific animation to play
    ///   - title: Optional title text to display above the animation
    ///   - message: Optional message text to display below the title
    static func riveAnimation(
        id: String = UUID().uuidString,
        riveName: String,
        stateMachineName: String? = nil,
        animationName: String? = nil,
        title: String? = nil,
        message: String? = nil
    ) -> UIState {
        .rive(
            id: id,
            riveName: riveName,
            stateMachineName: stateMachineName,
            animationName: animationName,
            title: title,
            message: message
        )
    }
}
