//
//  LocaLocApp.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 6/5/24.
//

import SwiftUI
import LocaLocDataRepository
import K_Logger

@main
struct CoreApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private let appCoordinator: AppCoordinator
    
    init() {
        do {
            let userDataRepository = try UserDataRepositoryImpl()
            let appCoordinator = AppCoordinator(userDataRepository: userDataRepository)
            
            self.appCoordinator = appCoordinator
        } catch {
            Log.error("Application initialization error: \(error)", module: "CoreApp")
            fatalError("Could not initialize application")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                appCoordinator.view()
            }
        }
    }
}
