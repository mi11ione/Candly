// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreArchitecture",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "CoreArchitecture",
            targets: ["CoreArchitecture"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CoreArchitecture",
            dependencies: []
        ),
    ]
)
