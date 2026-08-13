// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "InvertBinaryTree",
    targets: [
        .target(name: "InvertBinaryTree"),
        .testTarget(name: "InvertBinaryTreeTests", dependencies: ["InvertBinaryTree"]),
    ]
)
