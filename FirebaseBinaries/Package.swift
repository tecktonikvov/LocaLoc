// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseBinaries",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "FirebaseBinaries",
            targets: [
                // Reusable
                "FirebaseCoreExtension",
                "FirebaseSharedSwift",
                "leveldb-library",
                "FirebaseAppCheckInterop",
                
                // FirebaseAuth
                "FirebaseAuth",
                //"GTMSessionFetcher", // Throws an error when building
                "RecaptchaInterop",

                // FirebaseAnalytics
                "FBLPromises",
                "FirebaseAnalytics",
                "FirebaseAnalyticsSwift",
                "FirebaseCore",
                "FirebaseCoreInternal",
                "FirebaseInstallations",
                "GoogleAppMeasurement",
                "GoogleAppMeasurementIdentitySupport",
                "GoogleUtilities",
                "nanopb",
                
                // FirebaseCrashlytics
                "FirebaseCrashlytics",
                "FirebaseSessions",
                "GoogleDataTransport",
                "PromisesSwift",
                
                // FirebaseFirestore
                "abseil",
                "BoringSSL-GRPC",
                "FirebaseFirestore",
                "FirebaseFirestoreSwift",
                "gRPC-C++",
                "gRPC-Core",
                
                // FirebaseStorage
                "FirebaseAuthInterop",
                "FirebaseStorage",
            ])
    ],
    targets: [
        // Reusable
        .binaryTarget(name: "FirebaseCoreExtension", path: "Sources/FirebaseBinaries/FirebaseCrashlytics/FirebaseCoreExtension.xcframework"),
        .binaryTarget(name: "FirebaseSharedSwift", path: "Sources/FirebaseBinaries/FirebaseFirestore/FirebaseSharedSwift.xcframework"),
        .binaryTarget(name: "leveldb-library", path: "Sources/FirebaseBinaries/FirebaseFirestore/leveldb-library.xcframework"),
        .binaryTarget(name: "FirebaseAppCheckInterop", path: "Sources/FirebaseBinaries/FirebaseStorage/FirebaseAppCheckInterop.xcframework"),

        // FirebaseAuth
        .binaryTarget(name: "FirebaseAuth", path: "Sources/FirebaseBinaries/FirebaseAuth/FirebaseAuth.xcframework"),
//        .binaryTarget(name: "GTMSessionFetcher", path: "Sources/FirebaseBinaries/FirebaseAuth/GTMSessionFetcher.xcframework"),
        .binaryTarget(name: "RecaptchaInterop", path: "Sources/FirebaseBinaries/FirebaseAuth/RecaptchaInterop.xcframework"),
        
        // FirebaseAnalytics
        .binaryTarget(name: "FBLPromises", path: "Sources/FirebaseBinaries/FirebaseAnalytics/FBLPromises.xcframework"),
        .binaryTarget(name: "FirebaseAnalytics", path: "Sources/FirebaseBinaries/FirebaseAnalytics/FirebaseAnalytics.xcframework"),
        .binaryTarget(name: "FirebaseAnalyticsSwift", path: "Sources/FirebaseBinaries/FirebaseAnalytics/FirebaseAnalyticsSwift.xcframework"),
        .binaryTarget(name: "FirebaseCore", path: "Sources/FirebaseBinaries/FirebaseAnalytics/FirebaseCore.xcframework"),
        .binaryTarget(name: "FirebaseCoreInternal", path: "Sources/FirebaseBinaries/FirebaseAnalytics/FirebaseCoreInternal.xcframework"),
        .binaryTarget(name: "FirebaseInstallations", path: "Sources/FirebaseBinaries/FirebaseAnalytics/FirebaseInstallations.xcframework"),
        .binaryTarget(name: "GoogleAppMeasurement", path: "Sources/FirebaseBinaries/FirebaseAnalytics/GoogleAppMeasurement.xcframework"),
        .binaryTarget(name: "GoogleAppMeasurementIdentitySupport", path: "Sources/FirebaseBinaries/FirebaseAnalytics/GoogleAppMeasurementIdentitySupport.xcframework"),
        .binaryTarget(name: "GoogleUtilities", path: "Sources/FirebaseBinaries/FirebaseAnalytics/GoogleUtilities.xcframework"),
        .binaryTarget(name: "nanopb", path: "Sources/FirebaseBinaries/FirebaseAnalytics/nanopb.xcframework"),
        
        // FirebaseCrashlytics
        .binaryTarget(name: "FirebaseCrashlytics", path: "Sources/FirebaseBinaries/FirebaseCrashlytics/FirebaseCrashlytics.xcframework"),
        .binaryTarget(name: "FirebaseSessions", path: "Sources/FirebaseBinaries/FirebaseCrashlytics/FirebaseSessions.xcframework"),
        .binaryTarget(name: "GoogleDataTransport", path: "Sources/FirebaseBinaries/FirebaseCrashlytics/GoogleDataTransport.xcframework"),
        .binaryTarget(name: "PromisesSwift", path: "Sources/FirebaseBinaries/FirebaseCrashlytics/PromisesSwift.xcframework"),
        
        // FirebaseFirestore
        .binaryTarget(name: "abseil", path: "Sources/FirebaseBinaries/FirebaseFirestore/abseil.xcframework"),
        .binaryTarget(name: "BoringSSL-GRPC", path: "Sources/FirebaseBinaries/FirebaseFirestore/BoringSSL-GRPC.xcframework"),
        .binaryTarget(name: "FirebaseFirestore", path: "Sources/FirebaseBinaries/FirebaseFirestore/FirebaseFirestore.xcframework"),
        .binaryTarget(name: "FirebaseFirestoreSwift", path: "Sources/FirebaseBinaries/FirebaseFirestore/FirebaseFirestoreSwift.xcframework"),
        .binaryTarget(name: "gRPC-C++", path: "Sources/FirebaseBinaries/FirebaseFirestore/gRPC-C++.xcframework"),
        .binaryTarget(name: "gRPC-Core", path: "Sources/FirebaseBinaries/FirebaseFirestore/gRPC-Core.xcframework"),
        
        // FirebaseStorage
        .binaryTarget(name: "FirebaseAuthInterop", path: "Sources/FirebaseBinaries/FirebaseStorage/FirebaseAuthInterop.xcframework"),
        .binaryTarget(name: "FirebaseStorage", path: "Sources/FirebaseBinaries/FirebaseStorage/FirebaseStorage.xcframework")
    ]
)
