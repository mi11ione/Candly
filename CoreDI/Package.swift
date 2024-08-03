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
        .package(path: "../NetworkService"),
        .package(path: "../CoreRepository"),
        .package(path: "../SharedModels"),
        .package(path: "../RepositoryInterfaces"),
    ],
    targets: [
        .target(
            name: "CoreDI",
            dependencies: [
                "NetworkService",
                "CoreRepository",
                "SharedModels",
                "RepositoryInterfaces",
            ]
        ),
    ]
)
