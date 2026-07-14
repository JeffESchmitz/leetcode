// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "BestTimeToBuyAndSellStock",
    targets: [
        .target(name: "BestTimeToBuyAndSellStock"),
        .testTarget(name: "BestTimeToBuyAndSellStockTests", dependencies: ["BestTimeToBuyAndSellStock"]),
    ]
)
