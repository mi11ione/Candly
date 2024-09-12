// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DI",
    platforms: [.iOS(.v18), .macOS(.v15), .visionOS(.v2)],
    products: [
        .library(
            name: "DI",
            targets: ["DI"]
        ),
    ],
    dependencies: [
        .package(path: "../Data"),
        .package(path: "../Models"),
        .package(path: "../Network"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "DI",
            dependencies: [
                "Data",
                "Models",
                "Network",
                "Factory",
            ]
        ),
    ]
)
