// swift-tools-version:5.2

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
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.2.0"),
        .package(url: "https://github.com/elegantchaos/Logger.git", from: "1.5.5"),
        .package(url: "https://github.com/elegantchaos/SemanticVersion.git", from: "1.1.1"),
        .package(url: "https://github.com/elegantchaos/XCTestExtensions.git", from: "1.1.2"),
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
                "SemanticVersion",
            ]),

        .testTarget(
            name: "CommandShellTests",
            dependencies: ["CommandShell", "CommandShellExample", "XCTestExtensions"]),
    ]
)
