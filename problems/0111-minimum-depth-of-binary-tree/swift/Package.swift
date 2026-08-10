// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MinimumDepthOfBinaryTree",
    targets: [
        .target(name: "MinimumDepthOfBinaryTree"),
        .testTarget(name: "MinimumDepthOfBinaryTreeTests", dependencies: ["MinimumDepthOfBinaryTree"]),
    ]
)
