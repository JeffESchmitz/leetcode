// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MaximumAverageSubarray",
    targets: [
        .target(name: "MaximumAverageSubarray"),
        .testTarget(
            name: "MaximumAverageSubarrayTests",
            dependencies: ["MaximumAverageSubarray"]
        ),
    ]
)
