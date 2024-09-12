// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TickerFeature",
    platforms: [.iOS(.v18), .macOS(.v15), .visionOS(.v2)],
    products: [
        .library(
            name: "TickerFeature",
            targets: ["TickerFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../DI"),
        .package(path: "../Core"),
        .package(path: "../Models"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "TickerFeature",
            dependencies: [
                "DI",
                "Core",
                "Models",
                "Factory",
            ]
        ),
    ]
)
