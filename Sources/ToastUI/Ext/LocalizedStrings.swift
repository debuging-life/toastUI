//
//  LocalizedStrings.swift
//  ToastUI
//

import Foundation

/// Every string ToastUI puts on screen, in one place, translated through the
/// package's own string catalog rather than the app's.
enum L10n {
    static var ok: String { String(localized: "OK", bundle: .module) }
    static var cancel: String { String(localized: "Cancel", bundle: .module) }
    static var dismiss: String { String(localized: "Dismiss", bundle: .module) }
    static var copyMessage: String { String(localized: "Copy message", bundle: .module) }
    static var copied: String { String(localized: "Copied", bundle: .module) }
    static var collapse: String { String(localized: "Collapse", bundle: .module) }
    static var clearAll: String { String(localized: "Clear all", bundle: .module) }
    static var loading: String { String(localized: "Loading", bundle: .module) }
    static var progress: String { String(localized: "Progress", bundle: .module) }
    static var success: String { String(localized: "Success", bundle: .module) }
    static var error: String { String(localized: "Error", bundle: .module) }
    static var warning: String { String(localized: "Warning", bundle: .module) }
    static var inProgress: String { String(localized: "In progress", bundle: .module) }

    static func percent(_ value: Int) -> String {
        String(localized: "\(value) percent", bundle: .module)
    }

    static func notificationCount(_ count: Int) -> String {
        String(localized: "\(count) notifications", bundle: .module)
    }
}
