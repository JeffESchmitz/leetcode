// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FindGreatestCommonDivisorOfArray",
    targets: [
        .target(name: "FindGreatestCommonDivisorOfArray"),
        .testTarget(
            name: "FindGreatestCommonDivisorOfArrayTests",
            dependencies: ["FindGreatestCommonDivisorOfArray"]
        ),
    ]
)
