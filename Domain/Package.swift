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
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
                "SharedModels",
                "Data",
                "Factory",
            ]
        ),
    ]
)
