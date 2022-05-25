// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "StoryFlow",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "StoryFlow",
            targets: ["StoryFlow"]),
    ],
    targets: [
        .target(
            name: "StoryFlow"),
        .testTarget(
            name: "StoryFlowTests",
            dependencies: ["StoryFlow"]
        )
    ]
)
