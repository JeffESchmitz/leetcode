// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RotateArray",
    targets: [
        .target(name: "RotateArray"),
        .testTarget(name: "RotateArrayTests", dependencies: ["RotateArray"]),
    ]
)
