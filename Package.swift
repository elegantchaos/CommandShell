// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CommandShell",
    platforms: [
        .macOS(.v10_13), .iOS(.v12),
    ],
    products: [
        .library(name: "CommandShell", targets: ["CommandShell"])
    ],
    dependencies: [
        .package(url: "https://github.com/elegantchaos/Arguments.git", from: "1.1.1"),
        .package(url: "https://github.com/elegantchaos/Logger.git", from: "1.3.6"),
    ],
    targets: [
        .target(
            name: "CommandShell",
            dependencies: ["Arguments", "Logger"]),
        .testTarget(
            name: "CommandShellTests",
            dependencies: ["CommandShell"]),
    ]
)
