import Foundation
import Testing
@testable import ToastUI

@MainActor
struct ToastManagerTests {

    @Test func presentingAndDismissingAToast() {
        let manager = ToastManager()

        manager.success(title: "Run saved")
        #expect(manager.toasts.count == 1)
        #expect(manager.toasts.first?.type == .success)

        manager.dismiss(id: manager.toasts[0].id)
        #expect(manager.toasts.isEmpty)
    }

    @Test func toastsStackPerAlignment() {
        let manager = ToastManager()

        manager.info(title: "Top", alignment: .top)
        manager.info(title: "Bottom", alignment: .bottom)

        #expect(manager.toasts.filter { $0.alignment == .top }.count == 1)
        #expect(manager.toasts.filter { $0.alignment == .bottom }.count == 1)
    }

    @Test func theStackIsBounded() {
        let manager = ToastManager()
        manager.maximumToasts = 3

        for index in 0..<10 {
            manager.info(title: "Toast \(index)")
        }

        #expect(manager.toasts.count == 3)
        #expect(manager.toasts.first?.title == "Toast 7")   // the oldest made way
    }

    @Test func aSecondProgressToastUpdatesTheFirst() {
        let manager = ToastManager()

        manager.progress(title: "Uploading…")
        let firstID = manager.toasts[0].id
        manager.progress(title: "Uploading 50%")

        #expect(manager.toasts.count == 1)
        #expect(manager.toasts[0].id == firstID)       // same toast, no flicker
        #expect(manager.toasts[0].title == "Uploading 50%")
    }

    @Test func dismissAllClearsEverything() {
        let manager = ToastManager()
        manager.info(title: "One")
        manager.error(title: "Two")

        manager.dismissAll()

        #expect(manager.toasts.isEmpty)
    }

    // MARK: - Loading overlay

    @Test func progressOverlayReportsItsState() {
        let manager = ToastManager()
        #expect(manager.isProgressOverlayShowing == false)

        manager.showProgressOverlay(title: "Syncing")
        #expect(manager.isProgressOverlayShowing)
        #expect(manager.progressOverlay?.progress == nil)   // indeterminate by default

        manager.dismissProgressOverlay()
        #expect(manager.isProgressOverlayShowing == false)
    }

    @Test func progressUpdatesInPlaceAndIsClamped() {
        let manager = ToastManager()
        manager.showProgressOverlay(title: "Uploading", progress: 0)
        let id = manager.progressOverlay?.id

        manager.updateProgressOverlay(progress: 0.42, title: "Uploading 42%")
        #expect(manager.progressOverlay?.id == id)          // same panel, no re-animation
        #expect(manager.progressOverlay?.progress == 0.42)
        #expect(manager.progressOverlay?.title == "Uploading 42%")

        manager.updateProgressOverlay(progress: 5)
        #expect(manager.progressOverlay?.progress == 1)     // clamped

        manager.updateProgressOverlay(progress: -1)
        #expect(manager.progressOverlay?.progress == 0)
    }

    @Test func updatingWithNoOverlayShowingDoesNothing() {
        let manager = ToastManager()

        manager.updateProgressOverlay(progress: 0.5)

        #expect(manager.progressOverlay == nil)
    }

    @Test func aCancellableOverlayKeepsItsHandler() {
        let manager = ToastManager()
        var cancelled = false

        manager.showProgressOverlay(title: "Uploading", onCancel: { cancelled = true })
        manager.progressOverlay?.onCancel?()

        #expect(cancelled)
    }
}
