// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TickerFeature",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(name: "TickerFeature", targets: ["TickerFeature"]),
    ],
    dependencies: [
        .package(path: "../CoreUI"),
        .package(path: "../CoreDI"),
        .package(path: "../SharedModels"),
        .package(path: "../CoreRepository"),
        .package(path: "../CoreArchitecture"),
    ],
    targets: [
        .target(
            name: "TickerFeature",
            dependencies: [
                "CoreUI",
                "CoreDI",
                "SharedModels",
                "CoreRepository",
                "CoreArchitecture",
            ]
        ),
    ]
)
