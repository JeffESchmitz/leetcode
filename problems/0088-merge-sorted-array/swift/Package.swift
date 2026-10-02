// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MergeSortedArray",
    targets: [
        .target(name: "MergeSortedArray"),
        .testTarget(name: "MergeSortedArrayTests", dependencies: ["MergeSortedArray"]),
    ]
)
