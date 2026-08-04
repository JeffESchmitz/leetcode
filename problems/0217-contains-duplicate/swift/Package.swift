// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ContainsDuplicate",
    targets: [
        .target(name: "ContainsDuplicate"),
        .testTarget(name: "ContainsDuplicateTests", dependencies: ["ContainsDuplicate"]),
    ]
)
