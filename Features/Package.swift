// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "Features",
            targets: ["Features"]
        ),
    ],
    dependencies: [
        .package(path: "../DI"),
        .package(path: "../Core"),
        .package(path: "../Domain"),
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: [
                "DI",
                "Core",
                "Domain",
                "Factory",
            ]
        ),
    ]
)
