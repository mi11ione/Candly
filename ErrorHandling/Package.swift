// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ErrorHandling",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "ErrorHandling",
            targets: ["ErrorHandling"]
        ),
    ],
    targets: [
        .target(
            name: "ErrorHandling"
        ),
    ]
)
