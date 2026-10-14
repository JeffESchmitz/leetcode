// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ReverseWords",
    targets: [
        .target(name: "ReverseWords"),
        .testTarget(name: "ReverseWordsTests", dependencies: ["ReverseWords"]),
    ]
)
