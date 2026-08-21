// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NextGreaterElement",
    targets: [
        .target(name: "NextGreaterElement"),
        .testTarget(name: "NextGreaterElementTests", dependencies: ["NextGreaterElement"]),
    ]
)
