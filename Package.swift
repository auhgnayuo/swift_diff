// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "Diff",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .driverKit(.v19),
        .macCatalyst(.v13),
        .tvOS(.v12), .watchOS(.v4),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Diff",
            targets: ["Diff"]),
    ],
    targets: [
        .target(
            name: "Diff",
            dependencies: []),
        .testTarget(
            name: "DiffTests",
            dependencies: ["Diff"]),
    ])
