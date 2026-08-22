// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SingleNumber",
    targets: [
        .target(name: "SingleNumber"),
        .testTarget(name: "SingleNumberTests", dependencies: ["SingleNumber"]),
    ]
)
