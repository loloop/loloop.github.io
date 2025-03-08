// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IgniteStarter",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(path: "Ignite"),
        .package(url: "https://github.com/johnfairh/swift-sass.git", from: "3.1.0")
    ],
    targets: [
        .executableTarget(
            name: "IgniteStarter",
            dependencies: [
                "Ignite",
                .product(name: "DartSass", package: "swift-sass")
            ]
        ),
    ]
)
