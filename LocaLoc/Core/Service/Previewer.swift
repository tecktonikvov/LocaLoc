//
//  Previewer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftData
import LocaLocDataRepository
import LocaLocLocalStore

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
    
    class FakeLocalStorage: LocalStorage {
        func deleteAllModels(withTypes types: any PersistentModel.Type...) throws {
            
        }
        
        func fetchModelsWith<T>(model: T.Type, descriptor: FetchDescriptor<T>?) throws -> [T] where T: PersistentModel {
            return [T]()
        }
        
        func addModel(model: any PersistentModel) {
        }
        
        func delete(model: any PersistentModel) {
        }
        
        func save() throws {
        }
    }
    
    let localStorage = FakeLocalStorage()
    let userDataRepository: UserDataRepository = UserDataRepositoryPreviewHelper()
    let usernameManager: UsernameManager = UserDataRepositoryPreviewHelper()
    lazy var userPhotoUploader: UserPhotoUploader = FilesUploadingService(userDataRepository: userDataRepository)
    lazy var channelsRepository: ChannelsRepository = try! ChannelsDataRepository(localStorage: localStorage)
}

extension Previewer.UserDataRepositoryPreviewHelper: UsernameManager {
    func setUserName(_ username: String) async throws {
        
    }
    
    func isUsernameFree(_ username: String) async throws -> Bool {
        false
    }
}
