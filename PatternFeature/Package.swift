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
        .package(path: "../DI"),
        .package(path: "../Domain"),
        .package(path: "../CoreUI"),
        .package(path: "../SharedModels"),
        .package(path: "../CoreArchitecture"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "PatternFeature",
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
