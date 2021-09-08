// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "FTWaterFallLayout",
    platforms: [ .iOS(.v12), .macOS(.v10_14)],
    products: [
        .library(name: "FTWaterFallLayout", targets: ["FTWaterFallLayout"]),
    ],
    targets: [
        .target(name: "FTWaterFallLayout", path: "FTWaterFallLayout")
    ],
    swiftLanguageVersions: [.v5]
)
