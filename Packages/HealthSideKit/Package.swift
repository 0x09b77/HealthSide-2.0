// swift-tools-version: 6.2

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .defaultIsolation(MainActor.self),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
]

let package = Package(
    name: "HealthSideKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "HealthSideKit", targets: ["Core", "DesignSystem"]),
    ],
    targets: [
        .target(
            name: "Core",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DesignSystem",
            dependencies: ["Core"],
            resources: [.process("Resources")],
            swiftSettings: swiftSettings
        ),
    ]
)
