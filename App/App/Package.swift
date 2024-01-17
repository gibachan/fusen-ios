// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "App",
            targets: ["App"]),
        .library(
            name: "Domain",
            targets: ["Domain"]),
        .library(
            name: "Data",
            targets: ["Data"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.20.0"),
        .package(url: "https://github.com/realm/SwiftLint", exact: "0.52.4"),
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.6.0"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: []),
        .target(
            name: "Domain",
            dependencies: [
                .product(name: "FirebaseAppCheck", package: "firebase-ios-sdk"), // TODO: Remove this dependency
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"), // TODO: Remove this dependency
                .product(name: "FirebaseAnalyticsSwift", package: "firebase-ios-sdk"), // TODO: Remove this dependency
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"), // TODO: Remove this dependency
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"), // TODO: Remove this dependency
                .product(name: "FirebaseFunctions", package: "firebase-ios-sdk"), // TODO: Remove this
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"), // TODO: Remove this
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"), // TODO: Remove this
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"), // TODO: Remove this
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"), // TODO: Remove this
                .product(name: "FirebaseRemoteConfigSwift", package: "firebase-ios-sdk"), // TODO: Remove this
                .product(name: "Tagged",
                         package: "swift-tagged"),
            ]),
        .target(
            name: "Data",
            dependencies: ["Domain"]),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]),
    ]
)

// Append common plugins
package.targets = package.targets.map { target -> Target in
    if target.type == .regular || target.type == .test {
        if target.plugins == nil {
            target.plugins = []
        }
        target.plugins?.append(.plugin(name: "SwiftLintPlugin", package: "SwiftLint"))
    }

    return target
}
