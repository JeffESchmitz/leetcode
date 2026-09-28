// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ThreeSum",
    targets: [
        .target(name: "ThreeSum"),
        .testTarget(
            name: "ThreeSumTests",
            dependencies: ["ThreeSum"]
        ),
    ]
)
