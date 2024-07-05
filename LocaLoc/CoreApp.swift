//
//  LocaLocApp.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 6/5/24.
//

import SwiftUI
import Factory
import FirebaseCore
import GoogleMaps
 
@main
struct CoreApp: App {    
    private let appComposer: AppComposer
    @Injected(\.userDataRepository) private var userDataRepository
    
    // MARK: - Init
    init() {
        CoreApp.setupFirebaseApp()
        CoreApp.setupGmaps()
        
        let appComposer = AppComposer()
        self.appComposer = appComposer
        
        if let user = userDataRepository.currentUser {
            setCrashlyticsData(user: user)
        }
    }
    
    // MARK: - Private
    private func setCrashlyticsData(user: User) {
        CrashlyticsService.shared.set(userId: user.id)
        CrashlyticsService.shared.set(username: user.profile.username)
        CrashlyticsService.shared.set(userEmail: user.profile.email)
    }
    
    private static func setupFirebaseApp() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    private static func setupGmaps() {
        GMSServices.provideAPIKey("AIzaSyAtazBNVQVn-DE7QPmojFf7ClPiR9gEfbI")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                appComposer.view()
            }
        }
    }
}
