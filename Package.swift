// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToastUI",
    defaultLocalization: "en",
    platforms: [
        // iOS 17 / macOS 14: two-parameter `onChange`, Observation, and the Rive
        // runtime's own floor.
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10)
    ],
    products: [
        /// The core library: toasts, progress overlays, dialogs. No dependencies.
        .library(
            name: "ToastUI",
            targets: ["ToastUI"]
        ),
        /// Rive-powered icons, loading animations and celebrations.
        /// Add this product only if you want Rive; it pulls in the Rive runtime.
        .library(
            name: "ToastUIRive",
            targets: ["ToastUIRive"]
        ),
        /// The showcase screens. Opt in while building a demo; apps don't ship it.
        .library(
            name: "ToastUIExamples",
            targets: ["ToastUIExamples"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/rive-app/rive-ios", from: "6.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ToastUI",
            dependencies: [],
            resources: [.process("Resources")]
        ),
        .target(
            name: "ToastUIRive",
            dependencies: [
                "ToastUI",
                .product(name: "RiveRuntime", package: "rive-ios")
            ]
        ),
        .target(
            name: "ToastUIExamples",
            dependencies: ["ToastUI"]
        ),
        .testTarget(
            name: "ToastUITests",
            dependencies: ["ToastUI"]
        ),
    ]
)
