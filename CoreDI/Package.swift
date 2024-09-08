// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreDI",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "CoreDI",
            targets: ["CoreDI"]
        ),
    ],
    dependencies: [
        .package(path: "../Data"),
        .package(path: "../Domain"),
        .package(path: "../SharedModels"),
        .package(path: "../NetworkService"),
    ],
    targets: [
        .target(
            name: "CoreDI",
            dependencies: [
                "Data",
                "Domain",
                "SharedModels",
                "NetworkService",
            ]
        ),
    ]
)
