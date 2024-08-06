// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreRepository",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(name: "CoreRepository", targets: ["CoreRepository"]),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
        .package(path: "../NetworkService"),
        .package(path: "../ErrorHandling"),
    ],
    targets: [
        .target(
            name: "CoreRepository",
            dependencies: [
                "SharedModels",
                "NetworkService",
                "ErrorHandling",
            ]
        ),
    ]
)
