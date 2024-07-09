//
//  UserDataDataRepositoryImpl+UserDataRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftUI
import K_Logger
import LocaLocClient
import LocaLocLocalStore

// MARK: String+currentUserIdKey
fileprivate extension String {
    static let currentUserIdKey = "current_user_id"
}

enum UserDataDataRepositoryError: Error {
    case currentUserIsMissed
}

@Observable open class UserDataDataRepository {
    private(set) var currentUser: User?
    
    var userAuthenticationStatus: UserAuthenticationStatus {
        if let currentUser {
            if currentUser.profile.username.isEmpty {
                return .noUsername
            } else {
                return .authorized
            }
        } else {
            return .unauthorized
        }
    }
    
    let userNameClient: UserNameClient
    
    private let userDataClient: UserDataClient
    private let localStorage: LocalStorage
    
    // MARK: - Init
    init(localStorage: LocalStorage) throws {
        self.localStorage = localStorage
        
        let client = Client.shared
        
        self.userDataClient = UserDataClient(client: client)
        self.userNameClient = UserNameClient(client: client)
        
        try loadUser()
    }
    
    // MARK: - Private
    private func loadUser() throws {
        if let currentUserId = UserDefaults.standard.string(forKey: .currentUserIdKey),
           let storedUserModel = try storedUser(with: currentUserId) {
            currentUser = User(userLocalStoreModel: storedUserModel)
        }
    }
    
    private func storedUser(with id: String) throws -> UserPersistencyModel? {
        let users = try localStorage.fetchModelsWith(model: UserPersistencyModel.self, descriptor: nil)
        return users.first(where: { $0.id == id })
    }
    
    private func setUserToLocalStorage(_ userLocalStoreModel: UserPersistencyModel) throws {
        let userId = userLocalStoreModel.id
        
        do {
            // If user exist delete it
            if let existingUser = try storedUser(with: userId) {
                localStorage.delete(model: existingUser)
            }
            
            // Save updated user to local storage
            localStorage.addModel(model: userLocalStoreModel)
        } catch {
            Log.error("Local storage setting user data error: \(error)", module: "UserDataDataRepository")
            throw error
        }
    }
    
    private func setUserToClient(_ userClientModel: UserClientModel) async throws {
        do {
            try await userDataClient.setUserData(userId: userClientModel.id, data: userClientModel)
        } catch {
            Log.error("Client setting user data error: \(error)", module: "UserDataDataRepository")
            throw error
        }
    }
    
    private func setCurrentUser(_ user: User) {
        currentUser = user
    }
    
    private func getClientUserData(userId: String) async throws -> UserClientModel? {
        try await userDataClient.userData(userId: userId)
    }
    
    // MARK: - Public
    func setUserData(_ user: User, shouldUpdateClient: Bool) async throws {
        if shouldUpdateClient {
            let userClientModel = UserClientModel(userModel: user)
            try await setUserToClient(userClientModel)
        }
        
        let userLocalStoreModel = UserPersistencyModel(user: user)
        try setUserToLocalStorage(userLocalStoreModel)
        
        setCurrentUser(user)
    }
}

// MARK: UserDataRepository
extension UserDataDataRepository: UserDataRepository {
    func setAuthorizedUser(_ authorizationUserData: AuthorizationUserData) async throws {
        let user = authorizationUserData.user
        let isNewUser = authorizationUserData.isNewUser
        
        do {
            if isNewUser {
                try await setUserData(user, shouldUpdateClient: true)
            } else {
                if let existingUserClientModel = try await getClientUserData(userId: user.id) {
                    let existingUserModel = User(userClientModel: existingUserClientModel)
                    try await setUserData(existingUserModel, shouldUpdateClient: false)
                } else {
                    try await setUserData(user, shouldUpdateClient: true)
                }
            }
            
            UserDefaults.standard.set(user.id, forKey: .currentUserIdKey)
            Log.info("Set currentUserId: \(user.id)", module: "UserDataDataRepository")
        } catch {
            Log.error("Authorized user data setting up failed, error: \(error)", module: "UserDataDataRepository")
            throw error
        }
    }
    
    func updateUser(_ user: User) async throws {
        do {
            guard currentUser != nil else {
                throw UserDataDataRepositoryError.currentUserIsMissed
            }
            
            try await setUserData(user, shouldUpdateClient: true)
        } catch  {
            Log.error("User data update error: \(error)", module: "UserDataDataRepository")
            throw error
        }
    }
    
    func removeCurrentUserData() {
        UserDefaults.standard.removeObject(forKey: .currentUserIdKey)
        
        currentUser = nil
    }
}
