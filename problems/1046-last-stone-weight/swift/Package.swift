// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LastStoneWeight",
    targets: [
        .target(name: "LastStoneWeight"),
        .testTarget(
            name: "LastStoneWeightTests",
            dependencies: ["LastStoneWeight"]
        ),
    ]
)
