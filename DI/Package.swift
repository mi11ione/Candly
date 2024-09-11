// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DI",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "DI",
            targets: ["DI"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Data"),
        .package(path: "../Domain"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "DI",
            dependencies: [
                "Core",
                "Data",
                "Domain",
                "Factory",
            ]
        ),
    ]
)
