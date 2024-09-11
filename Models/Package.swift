// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Models",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "Models",
            targets: ["Models"]
        ),
    ],
    targets: [
        .target(
            name: "Models"
        ),
    ]
)
