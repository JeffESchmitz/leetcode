// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ValidPalindrome",
    targets: [
        .target(name: "ValidPalindrome"),
        .testTarget(name: "ValidPalindromeTests", dependencies: ["ValidPalindrome"]),
    ]
)
