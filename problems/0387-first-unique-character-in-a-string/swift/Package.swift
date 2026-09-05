// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FirstUniqueCharacter",
    targets: [
        .target(name: "FirstUniqueCharacter"),
        .testTarget(
            name: "FirstUniqueCharacterTests",
            dependencies: ["FirstUniqueCharacter"]
        ),
    ]
)
