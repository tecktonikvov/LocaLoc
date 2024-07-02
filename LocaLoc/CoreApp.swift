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
import LocaLocLocalStore
 
@main
struct CoreApp: App {    
    private let appComposer: AppComposer
    
    // MARK: - Init
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
                
        do {
            let localStorage = try AppLocalStorage(with: UserPersistencyModel.self,
                                                   ProfilePersistencyModel.self,
                                                   ChannelPersistencyModel.self,
                                                   ChannelUserSettingsPersistencyModel.self,
                                                   ChannelSettingsPersistencyModel.self)
            
            let userDataRepository = try UserDataDataRepository(localStorage: localStorage)
            let channelsRepository = try ChannelsDataRepository(localStorage: localStorage)
            
            let appComposer = AppComposer(
                userDataRepository: userDataRepository,
                usernameManager: userDataRepository,
                channelsRepository: channelsRepository
            )
            
            self.appComposer = appComposer
            
            if let user = userDataRepository.currentUser {
                setCrashlyticsData(user: user)
            }
        } catch {
            let errorString = "App initialization error: \(error)"
            
            Log.error(errorString, module: "CoreApp")
            fatalError(errorString)
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
