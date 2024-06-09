//
//  UserDataDataRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import SwiftUI
import K_Logger
import LocaLocClient
import LocaLocLocalStore

@Observable open class UserDataDataRepository {
    private(set) public var isUserAuthorized: Bool = false    
    private(set) public var _currentUser: UserPersistencyModel?
    
    private let userNameClient: UserNameClient
    private let userDataClient: UserDataClient
    private let localStorage: LocalStorage
    
    // MARK: - Init
    public init() throws {
        let client = Client()
        
        self.localStorage = try LocalStorage(with: UserPersistencyModel.self, ProfilePersistencyModel.self)
        self.userDataClient = UserDataClient(client: client)
        self.userNameClient = UserNameClient(client: client)

        try retrieveUser()
    }
    
    // MARK: - Private
    private func retrieveUser() throws {
        if let currentUserId = UserDefaults.standard.string(forKey: .currentUserIdKey),
           let currentUser = try storedUser(with: currentUserId) {
            self._currentUser = currentUser
            self.isUserAuthorized = true
        }
    }
    
    private func storedUser(with id: String) throws -> UserPersistencyModel? {
        let users = try localStorage.fetchModelsWith(model: UserPersistencyModel.self)
        return users.first(where: { $0.id == id })
    }
    
    private func setUserToLocalStorage(_ user: UserPersistencyModel) throws {
        let userId = user.id
        
        do {
            // If user exist delete it
            if let existingUser = try storedUser(with: userId) {
                localStorage.delete(model: existingUser)
            }
            
            // Save updated user to local storage
            localStorage.addModel(model: user)
        } catch {
            Log.error("Local storage setting user data error: \(error)", module: "UserDataDataRepository")
            throw error
        }
    }
    
    private func setUserToClient(_ user: UserPersistencyModel) throws {
        do {
            let userClientModel = UserClientModel(persistencyModel: user)
            try userDataClient.setUserData(userId: user.id, data: userClientModel)

        } catch {
            Log.error("Client setting user data error: \(error)", module: "UserDataDataRepository")
            throw error
        }
    }
    
    private func setCurrentUser(_ user: UserPersistencyModel) {
        self._currentUser = user
        isUserAuthorized = true
    }
    
    private func getClientUserData(userId: String) async throws -> UserPersistencyModel? {
        guard let userClientModel = try await userDataClient.userData(userId: userId) else {
            return nil
        }
        
        return UserPersistencyModel(clientModel: userClientModel)
    }
    
    private func updateUserData(_ user: UserPersistencyModel, shouldUpdateClient: Bool) throws {
        try setUserToLocalStorage(user)
        
        if shouldUpdateClient {
            try setUserToClient(user)
        }
        
        setCurrentUser(user)
    }
    
    private func triggerUIUpdate() {
        isUserAuthorized = isUserAuthorized
    }

    // MARK: - Public
    public func clearCurrentUserData() {
        UserDefaults.standard.removeObject(forKey: .currentUserIdKey)
        
        _currentUser = nil
        isUserAuthorized = false
    }

    public func updateUserData(_ user: UserPersistencyModel) throws {
        do {
            try updateUserData(user, shouldUpdateClient: true)
        } catch  {
            Log.error("User data update error: \(error)", module: "UserDataDataRepository")
            throw error
        }
    }

    public func setAuthorizedUser(_ user: UserPersistencyModel, isNewUser: Bool) throws {
        UserDefaults.standard.set(user.id, forKey: .currentUserIdKey)
                
        do {
            if isNewUser {
                try updateUserData(user, shouldUpdateClient: true)
            } else {
                Task { @MainActor in
                    if let existingUser = try await getClientUserData(userId: user.id) {
                        try updateUserData(existingUser, shouldUpdateClient: false)
                    } else {
                        try updateUserData(user, shouldUpdateClient: true)
                    }
                }
            }
                        
        } catch {
            Log.error("Authorized user data setting up failed, error: \(error)", module: "UserDataDataRepository")
            throw error
        }
    }
    
    public func isUsernameFree(username: String) async throws -> Bool {
        do {
            return try await userNameClient.isUsernameFree(username: username)
        } catch {
            Log.error("Is username free request error: \(error)", module: "UserDataDataRepository")
            return false
        }
    }
    
    public func set(username: String) async throws {
        do {
            guard let _currentUser else {
                throw UserDataDataRepositoryError.currentUserIsMissed
            }
            
            try await userNameClient.set(username: username, userId: _currentUser.id)
            _currentUser.profile.username = username
            
            triggerUIUpdate()
        } catch {
            Log.error("User name set request error: \(error)", module: "UserDataDataRepository")
        }
    }
}

// MARK: String+currentUserIdKey
fileprivate extension String {
    static let currentUserIdKey = "current_user_id"
}

// MARK: UserClientModel+UserPersistencyModel
fileprivate extension UserClientModel {
    init(persistencyModel: UserPersistencyModel) {
        self.init(
            id: persistencyModel.id,
            authenticationProviderType: persistencyModel.authenticationProviderType?.rawValue ?? "undefined",
            firstName: persistencyModel.profile.firstName,
            lastName: persistencyModel.profile.lastName,
            email: persistencyModel.profile.email,
            imageUrl: persistencyModel.profile.imageUrl,
            username: persistencyModel.profile.username
        )
    }
}

// MARK: UserPersistencyModel+UserClientModel
fileprivate extension UserPersistencyModel {
    convenience init(clientModel: UserClientModel) {
        let authenticationProviderType = AuthenticationProviderTypePersistencyModel(
            rawValue: clientModel.authenticationProviderType
        )
        
        let profile = ProfilePersistencyModel(
            firstName: clientModel.firstName,
            lastName: clientModel.lastName,
            email: clientModel.email,
            imageUrl: clientModel.imageUrl,
            username: clientModel.username
        )
        
        self.init(
            id: clientModel.id,
            authenticationProviderType: authenticationProviderType,
            profile: profile
        )
    }
}
