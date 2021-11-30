//swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Trekker",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "Trekker", targets: ["Trekker"]),
    ],
    targets: [
        .target(name: "Trekker", path: "Trekker"),
    ]
)
