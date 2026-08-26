// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MoveZeroes",
    targets: [
        .target(name: "MoveZeroes"),
        .testTarget(
            name: "MoveZeroesTests",
            dependencies: ["MoveZeroes"]
        ),
    ]
)
