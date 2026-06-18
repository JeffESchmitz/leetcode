// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TwoSum",
    targets: [
        .target(name: "TwoSum"),
        .testTarget(name: "TwoSumTests", dependencies: ["TwoSum"]),
    ]
)
