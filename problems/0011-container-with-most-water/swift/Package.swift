// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ContainerWithMostWater",
    targets: [
        .target(name: "ContainerWithMostWater"),
        .testTarget(
            name: "ContainerWithMostWaterTests",
            dependencies: ["ContainerWithMostWater"]
        ),
    ]
)
