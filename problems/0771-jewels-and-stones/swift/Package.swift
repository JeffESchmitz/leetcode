// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "JewelsAndStones",
    targets: [
        .target(name: "JewelsAndStones"),
        .testTarget(
            name: "JewelsAndStonesTests",
            dependencies: ["JewelsAndStones"]
        ),
    ]
)
