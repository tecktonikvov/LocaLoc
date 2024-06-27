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
    private let appComposer: AppComposer
    
    // MARK: - Init
    init() {
        FirebaseApp.configure()

        do {
            let userDataRepository = try UserDataDataRepository()

            let appComposer = AppComposer(
                userDataRepository: userDataRepository,
                usernameManager: userDataRepository
            )
            
            self.appComposer = appComposer
            
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
                appComposer.view()
            }
        }
    }
}
