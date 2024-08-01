// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RepositoryInterfaces",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(name: "RepositoryInterfaces", targets: ["RepositoryInterfaces"]),
    ],
    dependencies: [
        .package(path: "../SharedModels"),
    ],
    targets: [
        .target(name: "RepositoryInterfaces", dependencies: ["SharedModels"]),
    ]
)
