// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "QuickProcess",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/jwt.git", from: "4.2.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.92.5"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),
        .package(url: "https://github.com/saroar/ApiRequestSPM.git", branch: "main"),
//        .package(path: "../VFS_Bot"),
        .package(url: "https://github.com/orlandos-nl/BSON.git", from: "8.1.0"),
        .package(url: "https://github.com/orlandos-nl/MongoQueue.git", from: "1.2.0"),
        .package(url: "https://github.com/orlandos-nl/MongoKitten.git", from: "7.9.0"),
        .package(url: "https://github.com/orlandos-nl/IkigaJSON.git", from: "2.0.0"),
        .package(url: "https://github.com/pointfreeco/vapor-routing", from: "0.1.3"),
        // Mailgun
        .package(url: "https://github.com/vapor-community/mailgun.git", from: "5.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "JWT", package: "jwt"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Mailgun", package: "mailgun"),
                .product(name: "IkigaJSON", package: "IkigaJSON"),
                .product(name: "MongoQueue", package: "MongoQueue"),
                .product(name: "MongoKitten", package: "MongoKitten"),
                .product(name: "VaporRouting", package: "vapor-routing"),
                .product(name: "VFS_Bot", package: "ApiRequestSPM"),
//                "VFS_Bot"
            ],
            swiftSettings: [
              .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),

            // Workaround for https://github.com/apple/swift-package-manager/issues/6940
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Leaf", package: "leaf"),
        ])
    ]
)
