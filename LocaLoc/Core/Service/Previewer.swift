//
//  Previewer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftData
import LocaLocLocalStore
import Foundation

@MainActor
struct Previewer {
    class UserDataRepositoryPreviewHelper: UserDataRepository {
        func setAuthorizedUser(_ authorizationUserData: AuthorizationUserData) {
        }
        
        func updateUser(_ user: User) {
        }
        
        func updateUserProfile(_ profile: Profile, userId: String) {
        }
        
        var currentUser: User? {
            let profile = Profile(firstName: "Test first name", lastName: "Test Last name", email: "example@email.com", imageUrl: "", username: "testUsername")
            return User(
                id: "testUserId",
                authenticationProviderType: .google,
                profile: profile,
                createdAt: Date(),
                updatedAt: Date()
            )
        }
        
        var userAuthenticationStatus: UserAuthenticationStatus = .authorized
        
        func removeCurrentUserData() {
        }
    }
    
    class FakeLocalStorage: LocalStorage {
        func deleteAll<T>(model: T.Type, descriptor: FetchDescriptor<T>?) throws where T : PersistentModel {
            
        }
        
        func saveContext() throws {
            
        }
        
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
