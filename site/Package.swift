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
        .package(path: "Splash"),
        // Pinned to main for the Swift 6.4 fix; switch back to `from:` once 3.3.1+ is tagged.
        .package(url: "https://github.com/johnfairh/swift-sass.git", revision: "f7eaef42bd2272b269b4ba815a375441879f06db"),
        .package(url: "https://github.com/johnsundell/ink.git", from: "0.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "IgniteStarter",
            dependencies: [
                "Ignite",
                "Splash",
                .product(name: "Ink", package: "Ink"),
                .product(name: "DartSass", package: "swift-sass")
            ]
        ),
    ]
)
