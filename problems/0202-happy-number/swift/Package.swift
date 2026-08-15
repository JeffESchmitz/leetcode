// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "HappyNumber",
    targets: [
        .target(name: "HappyNumber"),
        .testTarget(name: "HappyNumberTests", dependencies: ["HappyNumber"]),
    ]
)
