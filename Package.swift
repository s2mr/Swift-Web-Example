// swift-tools-version:5.6
import PackageDescription
let package = Package(
    name: "Swift-Web-Example",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [
        .executable(name: "Swift-Web-Example", targets: ["Swift-Web-Example"])
    ],
    dependencies: [
        .package(url: "https://github.com/TokamakUI/Tokamak", from: "0.11.0")
    ],
    targets: [
        .executableTarget(
            name: "Swift-Web-Example",
            dependencies: [
                .product(name: "TokamakShim", package: "Tokamak")
            ]),
        .testTarget(
            name: "Swift-Web-ExampleTests",
            dependencies: ["Swift-Web-Example"]),
    ]
)