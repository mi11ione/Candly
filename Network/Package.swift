// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]
        ),
    ],
    dependencies: [
        .package(path: "../Models"),
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: [
                "Models",
            ]
        ),
    ]
)
