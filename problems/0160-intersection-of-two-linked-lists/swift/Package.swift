// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "IntersectionOfTwoLinkedLists",
    targets: [
        .target(name: "IntersectionOfTwoLinkedLists"),
        .testTarget(
            name: "IntersectionOfTwoLinkedListsTests",
            dependencies: ["IntersectionOfTwoLinkedLists"]
        ),
    ]
)
