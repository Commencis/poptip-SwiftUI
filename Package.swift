// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "poptip-SwiftUI",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "PoptipSwiftUI",
            targets: ["PoptipSwiftUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/andreamazz/AMPopTip", "4.5.0"..<"4.6.0")
    ],
    targets: [
        .target(
            name: "PoptipSwiftUI",
            dependencies: [.byName(name: "AMPopTip")]
        )
    ]
)
