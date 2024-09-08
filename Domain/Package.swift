// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]
        ),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
        .package(path: "../Data"),
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                "SharedModels",
                "Data",
            ]
        ),
    ]
)
