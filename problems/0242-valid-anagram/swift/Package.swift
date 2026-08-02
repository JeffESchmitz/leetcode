// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ValidAnagram",
    targets: [
        .target(name: "ValidAnagram"),
        .testTarget(name: "ValidAnagramTests", dependencies: ["ValidAnagram"]),
    ]
)
