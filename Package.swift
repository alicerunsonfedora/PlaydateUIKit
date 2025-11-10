// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlaydateUIKit",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PlaydateUIKit",
            targets: ["PlaydateUIKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://source.marquiskurt.net/PDUniverse/PlaydateKit.git", branch: "main"),
        .package(url: "https://github.com/strawdynamics/UTF8ViewExtensions.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
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
            ])
    ]
)
