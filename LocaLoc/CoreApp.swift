//
//  LocaLocApp.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 6/5/24.
//

import SwiftUI
import SwiftData

@main
struct CoreApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private let appCoordinator: AppCoordinator
    private let modelContainer: ModelContainer
    private let userDataRepository: UserDataRepository
    
    init() {
        do {
            let config = ModelConfiguration()
            let modelContainer = try ModelContainer(for: User.self, Profile.self, configurations: config)
            let modelContext = ModelContext(modelContainer)
            let userDataRepository = UserDataRepository(modelContext: modelContext)
            let appCoordinator = AppCoordinator(userDataRepository: userDataRepository)
            
            self.modelContainer = modelContainer
            self.userDataRepository = userDataRepository
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
