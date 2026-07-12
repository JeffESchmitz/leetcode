// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MergeTwoSortedLists",
    targets: [
        .target(name: "MergeTwoSortedLists"),
        .testTarget(name: "MergeTwoSortedListsTests", dependencies: ["MergeTwoSortedLists"]),
    ]
)
