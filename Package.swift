// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CommandShell",
    platforms: [
        .macOS(.v10_13), .iOS(.v12),
    ],
    products: [
        .library(name: "CommandShell", targets: ["CommandShell"]),
        .executable(name: "CommandShellExample", targets: ["CommandShellExample"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.4"),
        .package(url: "https://github.com/elegantchaos/Logger.git", from: "1.5.3"),
        .package(url: "https://github.com/elegantchaos/SemanticVersion.git", from: "1.0.2"),
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.0.11"),
    ],
    targets: [
        .target(
            name: "CommandShell",
            dependencies: [
                "Logger",
                "SemanticVersion",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),

        .target(
            name: "CommandShellExample",
            dependencies: [
                "CommandShell",
            ]),

        .testTarget(
            name: "CommandShellTests",
            dependencies: ["CommandShell", "CommandShellExample", "XCTestExtensions"]),
    ]
)
