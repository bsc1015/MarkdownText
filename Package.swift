// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarkdownText",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "MarkdownText",
            targets: ["MarkdownText"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/shaps80/swift-markdown", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/bsc1015/SwiftUIBackports", .branch(from: "main")),
    ],
    targets: [
        .target(
            name: "MarkdownText",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
                .byName(name: "SwiftUIBackports"),
            ]
        ),
    ]
)

