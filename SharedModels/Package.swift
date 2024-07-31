// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedModels",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(name: "SharedModels", targets: ["SharedModels"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SharedModels", dependencies: []),
    ]
)
