// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FindPivotIndex",
    targets: [
        .target(name: "FindPivotIndex"),
        .testTarget(name: "FindPivotIndexTests", dependencies: ["FindPivotIndex"]),
    ]
)
