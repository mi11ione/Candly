// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        ),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
        .package(path: "../NetworkService"),
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                "SharedModels",
                "NetworkService",
            ]
        ),
    ]
)
