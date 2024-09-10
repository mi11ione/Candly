// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SharedModels",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "SharedModels",
            dependencies: [
                "Factory",
            ]
        ),
    ]
)
