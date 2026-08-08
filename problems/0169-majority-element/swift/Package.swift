// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MajorityElement",
    targets: [
        .target(name: "MajorityElement"),
        .testTarget(name: "MajorityElementTests", dependencies: ["MajorityElement"]),
    ]
)
