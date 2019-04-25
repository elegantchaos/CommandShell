// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommandShell",
    products: [
        .library(name: "CommandShell", targets: ["CommandShell"])
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/Arguments", from: "1.0.7"),
    ],
    targets: [
        .target(
            name: "CommandShell",
            dependencies: ["Arguments"]),
        .testTarget(
            name: "CommandShellTests",
            dependencies: ["CommandShell"]),
    ]
)
