// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Sasho",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "Sasho",
            path: "Sources/Sasho",
            linkerSettings: [
                .linkedFramework("Carbon"),
                .linkedFramework("Cocoa"),
                .linkedFramework("ApplicationServices")
            ]
        )
    ]
)
