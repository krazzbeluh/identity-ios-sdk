// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "identity-ios-sdk",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "IdentitySdkCore",
            targets: ["IdentitySdkCore"]
        ),
        .library(
            name: "IdentitySdkFacebook",
            targets: ["IdentitySdkFacebook"]
        ),
        .library(
            name: "IdentitySdkGoogle",
            targets: ["IdentitySdkGoogle"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.0")),
        .package(url: "https://github.com/Thomvis/BrightFutures.git", .upToNextMajor(from: "8.2.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.8.0")),
        .package(url: "https://github.com/devicekit/DeviceKit.git", .upToNextMajor(from: "5.1.0")),
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", .upToNextMajor(from: "17.0.0")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", .upToNextMajor(from: "7.0.0")),
    ],
    targets: [
        .target(
            name: "IdentitySdkCore",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "DeviceKit", package: "DeviceKit"),
                .product(name: "BrightFutures", package: "BrightFutures"),
            ],
            path: "IdentitySdkCore"),
        .target(
            name: "IdentitySdkFacebook",
            dependencies: [
                .target(name: "IdentitySdkCore"),
                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                .product(name: "FacebookLogin", package: "facebook-ios-sdk"),
            ],
            path: "IdentitySdkFacebook"),
        .target(
            name: "IdentitySdkGoogle",
            dependencies: [
                .target(name: "IdentitySdkCore"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
            ],
            path: "IdentitySdkGoogle"),
    ]
)
