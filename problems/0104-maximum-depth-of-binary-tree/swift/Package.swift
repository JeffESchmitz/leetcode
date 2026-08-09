// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MaximumDepthOfBinaryTree",
    targets: [
        .target(name: "MaximumDepthOfBinaryTree"),
        .testTarget(name: "MaximumDepthOfBinaryTreeTests", dependencies: ["MaximumDepthOfBinaryTree"]),
    ]
)
