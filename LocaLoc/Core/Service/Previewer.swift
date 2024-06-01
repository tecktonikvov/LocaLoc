//
//  Previewer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let user: User
    let profile: Profile
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: User.self, Profile.self, configurations: config)
        profile = Profile(firstName: "Test first name", lastName: "Test Last name", email: "example@email.com", imageUrl: "", username: "testUsername")
        user = User(id: "testUserId", authenticationProviderType: .google, profile: profile)
        
        container.mainContext.insert(user)
    }
}
