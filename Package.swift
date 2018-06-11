// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "LiteAny",
    products: [
        .library(name: "LiteAny", targets: ["LiteAny"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "LiteAny", dependencies: []),
        .testTarget(name: "LiteAnyTests", dependencies: ["LiteAny"])
    ]
)
