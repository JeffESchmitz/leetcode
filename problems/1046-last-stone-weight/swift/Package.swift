// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LastStoneWeight",
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "LastStoneWeight",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(
            name: "LastStoneWeightTests",
            dependencies: ["LastStoneWeight"]
        ),
    ]
)
