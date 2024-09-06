// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(name: "NetworkService", targets: ["NetworkService"]),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: [
                "SharedModels",
            ]
        ),
    ]
)
