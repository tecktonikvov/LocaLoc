//
//  LocaLocApp.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 6/5/24.
//

import SwiftUI
import K_Logger
import FirebaseCore
import LocaLocDataRepository

@main
struct CoreApp: App {    
    private let appCoordinator: AppCoordinator
    
    // MARK: - Init
    init() {
        do {
            FirebaseApp.configure()

            let userDataRepository = try UserDataRepositoryImpl()
            let appCoordinator = AppCoordinator(userDataRepository: userDataRepository)
            
            self.appCoordinator = appCoordinator
            
            if let user = userDataRepository.currentUser {
                setCrashlyticsData(user: user)
            }
        } catch {
            Log.error("Application initialization error: \(error)", module: "CoreApp")
            fatalError("Could not initialize application")
        }
    }
    
    // MARK: - Private
    private func setCrashlyticsData(user: User) {
        CrashlyticsService.shared.set(userId: user.id)
        CrashlyticsService.shared.set(username: user.profile.username)
        CrashlyticsService.shared.set(userEmail: user.profile.email)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                appCoordinator.view()
            }
        }
    }
}
