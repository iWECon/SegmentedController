// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SegmentedController",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "SegmentedController", targets: ["SegmentedController"]),
    ],
    dependencies: [
        .package(url: "https://github.com/iWECon/Pager", from: "1.0.0"),
        .package(url: "https://github.com/iWECon/Segmenter", from: "2.0.0")
    ],
    targets: [
        .target(name: "SegmentedController", dependencies: ["Pager", "Segmenter"]),
    ]
)
