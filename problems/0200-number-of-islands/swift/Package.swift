// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NumberOfIslands",
    targets: [
        .target(name: "NumberOfIslands"),
        .testTarget(
            name: "NumberOfIslandsTests",
            dependencies: ["NumberOfIslands"]
        ),
    ]
)
