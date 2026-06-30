// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-bit-formatter-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        // MARK: - Library
        .library(
            name: "Bit Formatter Primitives",
            targets: ["Bit Formatter Primitives"]
        ),

        // MARK: - Test Support
        .library(
            name: "Bit Formatter Primitives Test Support",
            targets: ["Bit Formatter Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-bit-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-formatter-primitives.git", branch: "main"),
    ],
    targets: [
        // MARK: - Base-2 bit formatting
        //
        // `Bit.Formatter` — the base-2 bit formatter. Renders the bits of a
        // `Bit.Pattern<Carrier>.Mask` as `'0'`/`'1'` glyphs (no radix engine),
        // honoring `Bit.Order` and emitting fixed-width output.
        .target(
            name: "Bit Formatter Primitives",
            dependencies: [
                .product(name: "Bit Pattern Primitives", package: "swift-bit-primitives"),
                .product(name: "Formatter Primitives", package: "swift-formatter-primitives"),
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Bit Formatter Primitives Test Support",
            dependencies: [
                "Bit Formatter Primitives",
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests
        .testTarget(
            name: "Bit Formatter Primitives Tests",
            dependencies: [
                "Bit Formatter Primitives",
                "Bit Formatter Primitives Test Support",
            ],
            path: "Tests/Bit Formatter Primitives Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
