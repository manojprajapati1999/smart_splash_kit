// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "smart_splash_kit",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "smart-splash-kit",
            targets: ["smart_splash_kit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "smart_splash_kit",
            dependencies: [],
            path: "Sources/smart_splash_kit",
            publicHeadersPath: "."
        )
    ]
)
