import Foundation
import Testing
@testable import ToastUI

@MainActor
private func manager() -> ToastManager {
    let manager = ToastManager()
    manager.hapticsEnabled = false
    return manager
}

@MainActor
struct AutoDismissPausingTests {

    @Test func pausingKeepsToastsOnScreen() async throws {
        let toasts = manager()
        toasts.info(title: "First", duration: 0.05)
        toasts.setAutoDismissPaused(true)
        toasts.info(title: "Second", duration: 0.05)

        try await Task.sleep(for: .milliseconds(200))

        #expect(toasts.toasts.count == 2)   // nothing times out while paused
    }

    @Test func resumingLetsThemGoAgain() async throws {
        let toasts = manager()
        toasts.setAutoDismissPaused(true)
        toasts.info(title: "Waiting", duration: 0.05)

        try await Task.sleep(for: .milliseconds(120))
        #expect(toasts.toasts.count == 1)

        toasts.setAutoDismissPaused(false)
        try await Task.sleep(for: .milliseconds(200))
        #expect(toasts.toasts.isEmpty)
    }

    @Test func pausingTwiceIsHarmless() {
        let toasts = manager()
        toasts.setAutoDismissPaused(true)
        toasts.setAutoDismissPaused(true)
        #expect(toasts.isAutoDismissPaused)

        toasts.setAutoDismissPaused(false)
        #expect(toasts.isAutoDismissPaused == false)
    }
}

@MainActor
struct EventTests {

    @Test func showingAndDismissingAreReported() {
        let toasts = manager()
        var events: [String] = []
        toasts.onEvent = { event in
            switch event {
            case .shown(_, let title, _): events.append("shown:\(title)")
            case .dismissed(_, let reason): events.append("dismissed:\(reason)")
            default: events.append("other")
            }
        }

        toasts.success(title: "Saved")
        toasts.dismiss(id: toasts.toasts[0].id, reason: .userSwiped)

        #expect(events == ["shown:Saved", "dismissed:userSwiped"])
    }

    @Test func aReplacedGroupedToastReportsBothEvents() {
        let toasts = manager()
        var reasons: [ToastEvent.DismissReason] = []
        toasts.onEvent = { event in
            if case .dismissed(_, let reason) = event { reasons.append(reason) }
        }

        toasts.present(ToastMessage(title: "GPS lost", type: .warning, groupID: "gps"))
        toasts.present(ToastMessage(title: "GPS weak", type: .warning, groupID: "gps"))

        #expect(reasons == [.replaced])
    }
}

@MainActor
struct DialogTests {

    @Test func confirmReturnsWhatTheUserTapped() async {
        let toasts = manager()

        async let answer = toasts.confirm(title: "Delete activity?", confirm: "Delete", destructive: true)
        try? await Task.sleep(for: .milliseconds(50))
        #expect(toasts.dialog?.isDestructive == true)
        toasts.dialog?.respond(true)

        #expect(await answer)
        #expect(toasts.dialog == nil)   // closes itself
    }

    @Test func cancellingReturnsFalse() async {
        let toasts = manager()

        async let answer = toasts.confirm(title: "Delete activity?")
        try? await Task.sleep(for: .milliseconds(50))
        toasts.dismissDialog()

        #expect(await answer == false)
    }

    @Test func alertWaitsForTheButton() async {
        let toasts = manager()

        async let done: Void = toasts.alert(title: "Sync finished")
        try? await Task.sleep(for: .milliseconds(50))
        #expect(toasts.dialog?.cancelTitle == nil)   // one button only
        toasts.dialog?.respond(true)

        await done
        #expect(toasts.dialog == nil)
    }

    @Test func aSecondTapIsIgnored() async {
        let toasts = manager()

        async let answer = toasts.confirm(title: "Delete?")
        try? await Task.sleep(for: .milliseconds(50))
        let request = toasts.dialog
        request?.respond(true)
        request?.respond(false)   // a racing tap must not resume twice

        #expect(await answer)
    }
}

@MainActor
struct ThemeTests {

    @Test func theThemeSuppliesTheColour() {
        var theme = ToastTheme.default
        theme.colors[.success] = .purple

        #expect(theme.color(for: .success) == .purple)
        #expect(theme.color(for: .error) == ToastType.error.color)   // falls back
    }
}
