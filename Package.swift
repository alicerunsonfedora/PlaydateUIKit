// swift-tools-version: 6.1

import Foundation
import PackageDescription

/// Hack to force Xcode builds to not produce a dylib, since linking fails
/// without a toolset.json specified. Ideally this can be removed if/when
/// Xcode gains toolset.json support.
let xcode = (Context.environment["XPC_SERVICE_NAME"]?.count ?? 0) > 2

let package = Package(
    name: "PlaydateUIKit",
    platforms: [.macOS(.v14)],
    products: [
        .library(
            name: "PlaydateUIKitDemo",
            type: xcode ? nil : .dynamic,
            targets: ["PlaydateUIKitDemo", "PlaydateUIKit"]),
        .library(
            name: "PlaydateUIKit",
            targets: ["PlaydateUIKit"]
        )
    ],
    dependencies: [
        .package(url: "https://source.marquiskurt.net/PDUniverse/PlaydateKit.git", branch: "main"),
        .package(url: "https://github.com/strawdynamics/UTF8ViewExtensions.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "PlaydateUIKit",
            dependencies: [
                .product(name: "PlaydateKit", package: "PlaydateKit"),
                .product(name: "UTF8ViewExtensions", package: "UTF8ViewExtensions")
            ],
            exclude: ["Resources"],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags([
                    "-whole-module-optimization",
                    "-Xfrontend", "-disable-objc-interop",
                    "-Xfrontend", "-disable-stack-protector",
                    "-Xfrontend", "-function-sections",
                    "-Xfrontend", "-gline-tables-only",
                    "-Xcc", "-DTARGET_EXTENSION"
                ]),
            ]),
        .target(
            name: "PlaydateUIKitDemo",
            dependencies: [
                .product(name: "PlaydateKit", package: "PlaydateKit"),
                "PlaydateUIKit"
            ],
            exclude: ["Resources"],
            swiftSettings: [
                .enableExperimentalFeature("Embedded"),
                .unsafeFlags([
                    "-whole-module-optimization",
                    "-Xfrontend", "-disable-objc-interop",
                    "-Xfrontend", "-disable-stack-protector",
                    "-Xfrontend", "-function-sections",
                    "-Xfrontend", "-gline-tables-only",
                    "-Xcc", "-DTARGET_EXTENSION"
                ]),
            ],
        )
    ]
)
