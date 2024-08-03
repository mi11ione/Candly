// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreUI",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "CoreUI",
            targets: ["CoreUI"]
        ),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
    ],
    targets: [
        .target(
            name: "CoreUI",
            dependencies: [
                "SharedModels",
            ]
        ),
    ]
)
