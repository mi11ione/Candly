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
        .package(path: "../Data"),
        .package(path: "../Domain"),
        .package(path: "../CoreUI"),
        .package(path: "../CoreDI"),
        .package(path: "../SharedModels"),
        .package(path: "../CoreArchitecture"),
    ],
    targets: [
        .target(
            name: "TickerFeature",
            dependencies: [
                "Data",
                "Domain",
                "CoreUI",
                "CoreDI",
                "SharedModels",
                "CoreArchitecture",
            ]
        ),
    ]
)
