// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PalindromeNumber",
    targets: [
        .target(name: "PalindromeNumber"),
        .testTarget(name: "PalindromeNumberTests", dependencies: ["PalindromeNumber"]),
    ]
)
