// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v18), .macOS(.v15), .visionOS(.v2)],
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
