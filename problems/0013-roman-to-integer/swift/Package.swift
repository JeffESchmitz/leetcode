// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RomanToInteger",
    targets: [
        .target(name: "RomanToInteger"),
        .testTarget(name: "RomanToIntegerTests", dependencies: ["RomanToInteger"]),
    ]
)
