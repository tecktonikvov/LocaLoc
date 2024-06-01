//
//  Previewer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftData
import LocaLocDataRepository

@MainActor
struct Previewer {
    class UserDataRepositoryPreviewHelper: UserDataRepository {
        var currentUser: User? {
            let profile = Profile(firstName: "Test first name", lastName: "Test Last name", email: "example@email.com", imageUrl: "", username: "testUsername")
            return User(id: "testUserId", authenticationProviderType: .google, profile: profile)
        }
        
        var userAuthenticationStatus: UserAuthenticationStatus = .authorized
        
        func clearCurrentUserData() {
        }
        
        func setAuthorizedUser(_ user: User) {
        }
    }
    
    let userDataRepository: UserDataRepository = UserDataRepositoryPreviewHelper()
}
