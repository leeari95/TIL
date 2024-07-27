// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AriNote",
    products: [
        .library(name: "AriNote", targets: ["AriNote"]),
        .executable(name: "Scripts", targets: ["Scripts"]),
    ],
    dependencies: [.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")],
    targets: [
        .target(name: "AriNote"),
        .executableTarget(name: "Scripts"),
    ]
)
