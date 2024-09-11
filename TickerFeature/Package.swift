// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TickerFeature",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "TickerFeature",
            targets: ["TickerFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../DI"),
        .package(path: "../Domain"),
        .package(path: "../CoreUI"),
        .package(path: "../SharedModels"),
        .package(path: "../CoreArchitecture"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "TickerFeature",
            dependencies: [
                "DI",
                "Domain",
                "CoreUI",
                "Factory",
                "SharedModels",
                "CoreArchitecture",
            ]
        ),
    ]
)
