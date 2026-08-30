// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RemoveDuplicates",
    targets: [
        .target(name: "RemoveDuplicates"),
        .testTarget(
            name: "RemoveDuplicatesTests",
            dependencies: ["RemoveDuplicates"]
        ),
    ]
)
