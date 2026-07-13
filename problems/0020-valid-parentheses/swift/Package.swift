// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ValidParentheses",
    targets: [
        .target(name: "ValidParentheses"),
        .testTarget(name: "ValidParenthesesTests", dependencies: ["ValidParentheses"]),
    ]
)
