// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "AutoLayout",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "AutoLayout", type: .dynamic, targets: ["AutoLayout"]),
        .library(name: "AutoLayoutStatic", type: .static, targets: ["AutoLayout"])
    ],
    dependencies: [
        .package(url: "git@github.com:apple/swift-docc-plugin.git", branch: "main")
    ],
    targets: [
        .target(
            name: "AutoLayout",
            dependencies: [],
            path: "sources/main"
        ),
        .testTarget(
            name: "AutoLayoutTests",
            dependencies: ["AutoLayout"],
            path: "sources/tests"
        )
    ]
)
