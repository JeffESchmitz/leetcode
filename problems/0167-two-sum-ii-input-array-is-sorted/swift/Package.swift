// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TwoSumII",
    targets: [
        .target(name: "TwoSumII"),
        .testTarget(
            name: "TwoSumIITests",
            dependencies: ["TwoSumII"]
        ),
    ]
)
