// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Lidonica",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Lidonica",
            path: "Sources",
            resources: [
                .process("../Resources/Assets.xcassets"),
            ],
            linkerSettings: [
                .linkedFramework("IOKit"),
                .linkedFramework("AVFoundation"),
            ]
        ),
    ]
)
