// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ReverseLinkedList",
    targets: [
        .target(name: "ReverseLinkedList"),
        .testTarget(name: "ReverseLinkedListTests", dependencies: ["ReverseLinkedList"]),
    ]
)
