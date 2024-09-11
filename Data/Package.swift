// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        ),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Network"),
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                "Models",
                "Network",
            ]
        ),
    ]
)
