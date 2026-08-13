// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SameTree",
    targets: [
        .target(name: "SameTree"),
        .testTarget(name: "SameTreeTests", dependencies: ["SameTree"]),
    ]
)
