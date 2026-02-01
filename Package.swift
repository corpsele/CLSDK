// swift-tools-version:6.2.0
import PackageDescription

let package = Package(
    name: "CLSDK",

    platforms: [
        .iOS(.v12),
        .macOS(.v11_05),
    ],

    products: [
        .library(name: "CLSDK", targets: ["CLSDK"]),
    ],

    dependencies: [
        .package(url: "https://github.com/nicklockwood/LRUCache", from: "1.2.1"),
        .package(url: "https://github.com/swiftlang/swift-evolution", from: "1.3.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup", from: "2.11.3"),
        .package(url: "https://github.com/Swinject/Swinject", from: "2.10.0"),
        .package(url: "https://github.com/Swinject/SwinjectStoryboard", from: "2.2.3"),
    ],

    targets: [
        .target(
            name: "CLSDK",
//            dependencies: [
//                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
//            ],
//            path: "Sources/CLSDK",
//            resources: [
//                .process("Resources")
//            ]
        ),
        .testTarget(
            name: "CLSDKTests",
            dependencies: ["CLSDK"],
        ),
    ]
)
