// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MiddleOfTheLinkedList",
    targets: [
        .target(name: "MiddleOfTheLinkedList"),
        .testTarget(
            name: "MiddleOfTheLinkedListTests",
            dependencies: ["MiddleOfTheLinkedList"]
        ),
    ]
)
