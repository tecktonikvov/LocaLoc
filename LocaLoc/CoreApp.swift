//
//  LocaLocApp.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 6/5/24.
//

import SwiftUI
import DataRepository

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
            print("🔴", error)
            fatalError("Could not initialize ModelContainer")
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
