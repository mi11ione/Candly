// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]
        ),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: [
                "SharedModels",
                "Factory",
            ]
        ),
    ]
)
