// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FloodFill",
    targets: [
        .target(name: "FloodFill"),
        .testTarget(
            name: "FloodFillTests",
            dependencies: ["FloodFill"]
        ),
    ]
)
