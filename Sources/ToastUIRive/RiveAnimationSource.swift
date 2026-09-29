//
//  RiveAnimationSource.swift
//  ToastUIRive
//

import SwiftUI

/// Points at an animation inside a `.riv` file, plus the still image to show when
/// Rive can't run: Reduce Motion, a missing file, or a SwiftUI preview.
public struct RiveAnimationSource: Equatable, Sendable {
    /// File name in the bundle, without the `.riv` extension.
    public let asset: String
    public let stateMachine: String?
    public let artboard: String?
    /// Trigger input fired to replay the animation on a view that is already on screen.
    public let trigger: String?
    /// Number input (0...100) that a determinate loading animation follows.
    public let progressInput: String?
    /// SF Symbol drawn instead of the animation when Rive is unavailable.
    public let fallbackSymbol: String
    /// Bundle holding the file. Defaults to the app's main bundle.
    public let bundle: Bundle

    public init(asset: String,
                stateMachine: String? = "State Machine 1",
                artboard: String? = nil,
                trigger: String? = nil,
                progressInput: String? = nil,
                fallbackSymbol: String = "sparkles",
                bundle: Bundle = .main) {
        self.asset = asset
        self.stateMachine = stateMachine
        self.artboard = artboard
        self.trigger = trigger
        self.progressInput = progressInput
        self.fallbackSymbol = fallbackSymbol
        self.bundle = bundle
    }

    public static func == (lhs: RiveAnimationSource, rhs: RiveAnimationSource) -> Bool {
        lhs.asset == rhs.asset
            && lhs.stateMachine == rhs.stateMachine
            && lhs.artboard == rhs.artboard
            && lhs.trigger == rhs.trigger
            && lhs.progressInput == rhs.progressInput
            && lhs.fallbackSymbol == rhs.fallbackSymbol
            && lhs.bundle == rhs.bundle
    }
}
