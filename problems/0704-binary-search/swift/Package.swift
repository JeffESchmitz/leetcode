// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "BinarySearch",
    targets: [
        .target(name: "BinarySearch"),
        .testTarget(name: "BinarySearchTests", dependencies: ["BinarySearch"]),
    ]
)
