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
        func setAuthorizedUser(_ authorizationUserData: AuthorizationUserData) {
        }
        
        func updateCurrentUser(_ user: User) {
        }
        
        func updateUserProfile(_ profile: Profile, userId: String) {
        }
        
        var currentUser: User? {
            let profile = Profile(firstName: "Test first name", lastName: "Test Last name", email: "example@email.com", imageUrl: "", username: "testUsername")
            return User(id: "testUserId", authenticationProviderType: .google, profile: profile)
        }
        
        var userAuthenticationStatus: UserAuthenticationStatus = .authorized
        
        func clearCurrentUserData() {
        }
    }
    
    let userDataRepository: UserDataRepository = UserDataRepositoryPreviewHelper()
    let usernameManager: UsernameManager = UserDataRepositoryPreviewHelper()
}

extension Previewer.UserDataRepositoryPreviewHelper: UsernameManager {
    func setUserName(_ username: String) async throws {
        
    }
    
    func isUsernameFree(_ username: String) async throws -> Bool {
        false
    }
}
