// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToastUI",
    platforms: [
        .iOS(.v16),
        .macOS("13.1")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ToastUI",
            targets: ["ToastUI"]
        ),
    ],
    dependencies: [
        // RiveRuntime for Rive animation support (optional)
        .package(url: "https://github.com/rive-app/rive-ios", from: "6.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ToastUI",
            dependencies: [
                .product(name: "RiveRuntime", package: "rive-ios")
            ]
        ),
        .testTarget(
            name: "ToastUITests",
            dependencies: ["ToastUI"]
        ),
    ]
)
