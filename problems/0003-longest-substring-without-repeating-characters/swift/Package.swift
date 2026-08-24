// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LongestSubstring",
    targets: [
        .target(name: "LongestSubstring"),
        .testTarget(
            name: "LongestSubstringTests",
            dependencies: ["LongestSubstring"]
        ),
    ]
)
