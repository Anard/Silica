// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Silica",
    products: [
    	.library(
    		name: "Silica",
    		targets: ["Silica"]
    	)
    ],
    dependencies: [
        .package(
            url: "../Cairo", 
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "Silica",
            dependencies: ["Cairo"]
        )
    ]
)
