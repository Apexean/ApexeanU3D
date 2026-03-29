// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "ApexeanU3D",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Apexean U 3D", targets: ["ApexeanU3D"])
    ],
    targets: [
        .executableTarget(
            name: "ApexeanU3D",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("SceneKit")
            ]
        )
    ]
)
