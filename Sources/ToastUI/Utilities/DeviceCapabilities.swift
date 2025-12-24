//
//  DeviceCapabilities.swift
//  ToastUI
//
//  Created by Pardip Bhatti on 24/12/25.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

struct DeviceCapabilities {

    /// Checks if the device is running iOS 26 or later
    static var supportsGlassEffect: Bool {
        #if os(iOS)
        if #available(iOS 26.0, *) {
            return true
        }
        return false
        #else
        return false
        #endif
    }

    /// Returns the current iOS version as a string
    static var iOSVersion: String {
        #if os(iOS)
        return UIDevice.current.systemVersion
        #else
        return "N/A"
        #endif
    }

    /// Returns the major iOS version number
    static var iOSMajorVersion: Int {
        #if os(iOS)
        let version = UIDevice.current.systemVersion
        if let majorVersion = version.split(separator: ".").first,
           let majorInt = Int(majorVersion) {
            return majorInt
        }
        return 0
        #else
        return 0
        #endif
    }
}
