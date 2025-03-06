// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swiftui-flow-grids",
    platforms: [
        .iOS(.v16),
        .macCatalyst(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .visionOS(.v1),
        .watchOS(.v9),
    ],
    products: [
        .library(
            name: "FlowGrids",
            targets: ["FlowGrids"])
    ],
    targets: [
        .target(name: "FlowGrids"),
        .testTarget(
            name: "FlowGridsTests",
            dependencies: ["FlowGrids"]
        ),
    ]
)
