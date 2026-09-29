//
//  AccessibilityAnnouncer.swift
//  ToastUI
//

import SwiftUI

/// Speaks a toast as it appears. A toast that only flashes on screen is invisible
/// to a VoiceOver user, and toasts are often the only report that something worked.
enum AccessibilityAnnouncer {
    @MainActor
    static func announce(_ text: String) {
        guard !text.isEmpty else { return }
        #if os(iOS) || os(tvOS) || os(watchOS)
        guard UIAccessibility.isVoiceOverRunning else { return }
        // A short delay lets the toast's own view land first, so the announcement
        // isn't cut off by the layout change VoiceOver also reports.
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(150))
            UIAccessibility.post(notification: .announcement, argument: text)
        }
        #elseif os(macOS)
        guard let window = NSApp.keyWindow else { return }
        NSAccessibility.post(
            element: window,
            notification: .announcementRequested,
            userInfo: [.announcement: text, .priority: NSAccessibilityPriorityLevel.high.rawValue]
        )
        #endif
    }
}
