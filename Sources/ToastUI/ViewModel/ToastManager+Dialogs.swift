//
//  ToastManager+Dialogs.swift
//  ToastUI
//

import SwiftUI

public extension ToastManager {

    /// Asks a yes/no question and waits for the answer — no bindings, no callbacks:
    ///
    ///     if await toast.confirm(title: "Delete activity?",
    ///                            message: "This can't be undone.",
    ///                            confirm: "Delete", destructive: true) {
    ///         await store.delete(activity)
    ///     }
    ///
    /// Returns false if the user cancels or taps outside.
    @MainActor
    func confirm(title: String,
                 message: String? = nil,
                 confirm: String? = nil,
                 cancel: String? = nil,
                 destructive: Bool = false) async -> Bool {
        await withCheckedContinuation { continuation in
            var answered = false
            dialog = DialogRequest(
                title: title,
                message: message,
                confirmTitle: confirm ?? L10n.ok,
                cancelTitle: cancel ?? L10n.cancel,
                isDestructive: destructive
            ) { [weak self] answer in
                guard !answered else { return }   // taps can race the dismissal
                answered = true
                self?.dialog = nil
                continuation.resume(returning: answer)
            }
        }
    }

    /// Tells the user something and waits for the acknowledgement.
    @MainActor
    func alert(title: String,
               message: String? = nil,
               button: String? = nil) async {
        _ = await withCheckedContinuation { (continuation: CheckedContinuation<Bool, Never>) in
            var answered = false
            dialog = DialogRequest(
                title: title,
                message: message,
                confirmTitle: button ?? L10n.ok,
                cancelTitle: nil,
                isDestructive: false
            ) { [weak self] _ in
                guard !answered else { return }
                answered = true
                self?.dialog = nil
                continuation.resume(returning: true)
            }
        }
    }

    /// Closes the dialog from code, answering false.
    @MainActor
    func dismissDialog() {
        dialog?.respond(false)
        dialog = nil
    }
}
