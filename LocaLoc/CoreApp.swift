//
//  LocaLocApp.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 6/5/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CoreApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appCoordinator = AppCoordinator(path: NavigationPath(), dataRepository: DataRepository.shared)
    @State private var shouldShowAuthentication = false

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appCoordinator.path) {
                appCoordinator.view()
                    .fullScreenCover(isPresented: $shouldShowAuthentication) {
                        let authenticationCoordinator = AuthenticationCoordinator(
                            page: .providers,
                            navigationPath: $appCoordinator.path
                        )
                        authenticationCoordinator.view()
                    }
            }
            .environmentObject(appCoordinator)
        }
    }
}
