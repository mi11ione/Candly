// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreDI",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(
            name: "CoreDI",
            targets: ["CoreDI"]
        ),
    ],
    dependencies: [
        .package(path: "../NetworkService"),
        .package(path: "../CoreRepository"),
    ],
    targets: [
        .target(
            name: "CoreDI",
            dependencies: ["NetworkService", "CoreRepository"]
        ),
    ]
)
