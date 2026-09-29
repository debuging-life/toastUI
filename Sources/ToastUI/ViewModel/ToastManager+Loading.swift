//
//  ToastManager+Loading.swift
//  ToastUI
//

import SwiftUI

public extension ToastManager {

    /// Runs work behind a loading overlay and always takes the overlay away again —
    /// on success, on a thrown error, and on cancellation.
    ///
    ///     let run = try await toast.withLoading("Uploading run", cancellable: true) { report in
    ///         try await api.upload(run) { report($0) }   // 0...1
    ///     }
    ///
    /// - Parameters:
    ///   - determinate: start with a percentage ring rather than a spinner.
    ///   - cancellable: shows Cancel, which cancels the task running `operation`.
    ///   - errorTitle: when set, a failure also shows an error toast.
    @discardableResult
    @MainActor
    func withLoading<T: Sendable>(
        _ title: String,
        message: String? = nil,
        determinate: Bool = false,
        cancellable: Bool = false,
        configuration: ProgressOverlayConfiguration = .default,
        errorTitle: String? = nil,
        operation: @escaping @Sendable (@escaping @MainActor (Double) -> Void) async throws -> T
    ) async throws -> T {
        let report: @MainActor (Double) -> Void = { [weak self] progress in
            self?.updateProgressOverlay(progress: progress)
        }

        let task = Task { try await operation(report) }

        showProgressOverlay(
            title: title,
            message: message,
            configuration: configuration,
            progress: determinate ? 0 : nil,
            onCancel: cancellable ? { task.cancel() } : nil
        )
        defer { dismissProgressOverlay() }

        do {
            return try await task.value
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            if let errorTitle {
                dismissProgressOverlay()   // the toast should not land behind the panel
                self.error(title: errorTitle, message: error.localizedDescription)
            }
            throw error
        }
    }

    /// Same, for work that reports no progress.
    @discardableResult
    @MainActor
    func withLoading<T: Sendable>(
        _ title: String,
        message: String? = nil,
        cancellable: Bool = false,
        errorTitle: String? = nil,
        operation: @escaping @Sendable () async throws -> T
    ) async throws -> T {
        try await withLoading(title,
                              message: message,
                              cancellable: cancellable,
                              errorTitle: errorTitle) { _ in try await operation() }
    }
}
