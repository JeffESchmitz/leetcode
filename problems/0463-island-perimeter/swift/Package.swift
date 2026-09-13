// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "IslandPerimeter",
    targets: [
        .target(name: "IslandPerimeter"),
        .testTarget(
            name: "IslandPerimeterTests",
            dependencies: ["IslandPerimeter"]
        ),
    ]
)
