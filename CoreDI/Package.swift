// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDI",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "CoreDI",
            targets: ["CoreDI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoreDI",
            dependencies: []
        ),
    ]
)
