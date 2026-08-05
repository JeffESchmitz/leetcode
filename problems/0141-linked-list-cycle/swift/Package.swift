// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LinkedListCycle",
    targets: [
        .target(name: "LinkedListCycle"),
        .testTarget(name: "LinkedListCycleTests", dependencies: ["LinkedListCycle"]),
    ]
)
