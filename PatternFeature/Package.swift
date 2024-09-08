// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PatternFeature",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "PatternFeature",
            targets: ["PatternFeature"]
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
            name: "PatternFeature",
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
