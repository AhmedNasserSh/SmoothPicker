// swift-tools-version:5.0
import PackageDescription

let package = Package(
        name: "SmoothPicker",
        platforms: [.iOS(.v10)],
        products: [.library(name: "SmoothPicker",
                            targets: ["SmoothPicker"])],
        dependencies: [.package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.1")],
        targets: [.target(name: "SmoothPicker",
                          dependencies: ["SnapKit"],
                          path: "SmoothPicker/Classes")]
)