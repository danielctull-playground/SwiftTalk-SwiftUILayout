// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftUILayout",
    platforms: [
        .macOS(.v11),
    ],
    products: [
        .executable(name: "SwiftUILayout", targets: ["SwiftUILayout"]),
        .library(name: "UI", targets: ["UI"]),
    ],
    targets: [
        .target(name: "UI"),
        .target(name: "SwiftUILayout", dependencies: ["UI"]),
    ]
)
