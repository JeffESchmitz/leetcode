// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RemoveDuplicatesII",
    targets: [
        .target(name: "RemoveDuplicatesII"),
        .testTarget(name: "RemoveDuplicatesIITests", dependencies: ["RemoveDuplicatesII"]),
    ]
)
