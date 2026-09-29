//
//  RiveAnimationView.swift
//  ToastUIRive
//

import RiveRuntime
import SwiftUI

// RiveRuntime exports its own `Color`, so SwiftUI's is spelled out in this module.
public typealias RiveToastColor = SwiftUI.Color

/// Plays a `RiveAnimationSource`, falling back to its SF Symbol when Rive can't run.
///
/// Pass `progress` (0...1) and give the source a `progressInput` to drive a
/// determinate loading animation from real upload progress.
public struct RiveAnimationView: View {
    private let source: RiveAnimationSource
    private let size: CGFloat
    private let tint: RiveToastColor
    private let progress: Double?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var model: RiveViewModel?

    public init(_ source: RiveAnimationSource,
                size: CGFloat = 96,
                tint: RiveToastColor = .primary,
                progress: Double? = nil) {
        self.source = source
        self.size = size
        self.tint = tint
        self.progress = progress
    }

    public var body: some View {
        Group {
            if let model, !reduceMotion {
                model.view()
                    .frame(width: size, height: size)
                    .onAppear { replay(model) }
            } else {
                Image(systemName: source.fallbackSymbol)
                    .font(.system(size: size * 0.55, weight: .bold))
                    .foregroundStyle(tint)
                    .frame(width: size, height: size)
            }
        }
        .accessibilityHidden(true)   // the surrounding title and message carry the meaning
        .task(id: source) {
            guard !reduceMotion else { return }
            model = RiveAnimationCache.shared.viewModel(for: source)
            if let model { apply(progress, to: model) }
        }
        .onChange(of: progress) { _, newValue in
            guard let model else { return }
            apply(newValue, to: model)
        }
        .onDisappear { model?.stop() }   // Rive keeps a display link running otherwise
    }

    private func replay(_ model: RiveViewModel) {
        if let trigger = source.trigger {
            model.triggerInput(trigger)
        } else {
            model.play()
        }
    }

    private func apply(_ progress: Double?, to model: RiveViewModel) {
        guard let progress, let input = source.progressInput else { return }
        model.setInput(input, value: Float(min(max(progress, 0), 1) * 100))
    }
}

/// Loads each `.riv` once and hands out a view model per use.
///
/// `RiveViewModel(fileName:)` force-tries internally and crashes on a missing file,
/// so loading goes through the throwing `RiveFile` API and returns nil instead —
/// a renamed asset degrades to the fallback symbol rather than taking the app down.
@MainActor
public final class RiveAnimationCache {
    public static let shared = RiveAnimationCache()

    private var files: [String: RiveFile] = [:]
    private var warned: Set<String> = []

    public func viewModel(for source: RiveAnimationSource) -> RiveViewModel? {
        guard let file = file(for: source) else { return nil }
        let model = RiveModel(riveFile: file)
        if let stateMachine = source.stateMachine {
            return RiveViewModel(model,
                                 stateMachineName: stateMachine,
                                 fit: .contain,
                                 autoPlay: true,
                                 artboardName: source.artboard)
        }
        return RiveViewModel(model,
                             animationName: nil,
                             fit: .contain,
                             autoPlay: true,
                             artboardName: source.artboard)
    }

    /// Drops the cached files, e.g. on a memory warning.
    public func purge() {
        files.removeAll()
    }

    private func file(for source: RiveAnimationSource) -> RiveFile? {
        let key = "\(source.bundle.bundleIdentifier ?? "main").\(source.asset)"
        if let cached = files[key] { return cached }
        guard let url = source.bundle.url(forResource: source.asset, withExtension: "riv") else {
            warnOnce(key, reason: "not found in \(source.bundle.bundlePath)")
            return nil
        }
        do {
            let file = try RiveFile(data: Data(contentsOf: url), loadCdn: false)
            files[key] = file
            return file
        } catch {
            warnOnce(key, reason: "\(error)")
            return nil
        }
    }

    private func warnOnce(_ key: String, reason: String) {
        guard warned.insert(key).inserted else { return }
        print("[ToastUIRive] Couldn't load '\(key).riv' — showing the fallback symbol instead. \(reason)")
    }
}
