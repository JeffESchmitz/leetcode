// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TrappingRainWater",
    targets: [
        .target(name: "TrappingRainWater"),
        .testTarget(
            name: "TrappingRainWaterTests",
            dependencies: ["TrappingRainWater"]
        ),
    ]
)
