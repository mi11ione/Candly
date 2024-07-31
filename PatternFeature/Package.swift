// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PatternFeature",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "PatternFeature",
            targets: ["PatternFeature"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PatternFeature",
            dependencies: []
        ),
    ]
)
