// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ClimbingStairs",
    targets: [
        .target(name: "ClimbingStairs"),
        .testTarget(name: "ClimbingStairsTests", dependencies: ["ClimbingStairs"]),
    ]
)
