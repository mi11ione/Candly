// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Models",
    platforms: [.iOS(.v18), .macOS(.v15), .visionOS(.v2)],
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
