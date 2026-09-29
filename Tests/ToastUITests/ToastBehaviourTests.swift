import Foundation
import Testing
@testable import ToastUI

@MainActor
private func silentManager() -> ToastManager {
    let manager = ToastManager()
    manager.hapticsEnabled = false   // no device feedback in tests
    return manager
}

@MainActor
struct ToastGroupingTests {

    @Test func aGroupedToastReplacesTheOneOnScreen() {
        let manager = silentManager()

        manager.present(ToastMessage(title: "GPS signal lost", type: .warning, groupID: "gps"))
        manager.present(ToastMessage(title: "GPS signal lost", type: .warning, groupID: "gps"))
        manager.present(ToastMessage(title: "GPS signal weak", type: .warning, groupID: "gps"))

        #expect(manager.toasts.count == 1)
        #expect(manager.toasts[0].title == "GPS signal weak")
    }

    @Test func ungroupedToastsStillStack() {
        let manager = silentManager()

        manager.info(title: "One")
        manager.info(title: "Two")

        #expect(manager.toasts.count == 2)
    }

    @Test func theLeastImportantToastIsEvictedFirst() {
        let manager = silentManager()
        manager.maximumToasts = 2

        manager.error(title: "Upload failed")
        manager.info(title: "Synced")
        manager.info(title: "Synced again")

        #expect(manager.toasts.count == 2)
        #expect(manager.toasts.contains { $0.type == .error })   // the failure survived
    }
}

@MainActor
struct StickyAndActionTests {

    @Test func aStickyToastOutlivesItsDuration() async throws {
        let manager = silentManager()

        manager.present(ToastMessage(title: "You're offline", type: .warning,
                                     duration: 0.05, isSticky: true))
        manager.present(ToastMessage(title: "Saved", type: .success, duration: 0.05))

        try await Task.sleep(for: .milliseconds(250))

        #expect(manager.toasts.count == 1)
        #expect(manager.toasts[0].title == "You're offline")
    }

    @Test func anActionRunsItsHandler() {
        var undone = false
        let action = ToastAction(title: "Undo") { undone = true }

        action.handler()

        #expect(undone)
        #expect(action.dismissesToast)
    }

    @Test func hapticsCanBeObservedAndSilenced() {
        let manager = ToastManager()
        var played: [ToastType] = []
        manager.haptics = { played.append($0) }

        manager.success(title: "Saved")
        manager.error(title: "Failed")

        #expect(played == [.success, .error])
    }
}

@MainActor
struct WithLoadingTests {

    struct Failure: Error {}

    @Test func itShowsTheOverlayReportsProgressAndTakesItAwayAgain() async throws {
        let manager = silentManager()

        let result = try await manager.withLoading("Uploading", determinate: true) { report in
            await MainActor.run { report(0.5) }
            return 42
        }

        #expect(result == 42)
        #expect(manager.isProgressOverlayShowing == false)   // always cleaned up
    }

    @Test func aFailureClearsTheOverlayAndCanShowAToast() async {
        let manager = silentManager()

        await #expect(throws: Failure.self) {
            try await manager.withLoading("Uploading", errorTitle: "Upload failed") { _ in
                throw Failure()
            }
        }

        #expect(manager.isProgressOverlayShowing == false)
        #expect(manager.toasts.contains { $0.type == .error && $0.title == "Upload failed" })
    }

    @Test func cancellingStopsTheWorkAndTheOverlay() async {
        let manager = silentManager()

        let task = Task {
            try await manager.withLoading("Uploading", cancellable: true) { _ in
                try await Task.sleep(for: .seconds(5))
                return "finished"
            }
        }
        try? await Task.sleep(for: .milliseconds(50))
        await MainActor.run { manager.progressOverlay?.onCancel?() }

        let result = await task.result
        #expect(throws: CancellationError.self) { try result.get() }
        #expect(manager.isProgressOverlayShowing == false)
    }
}
