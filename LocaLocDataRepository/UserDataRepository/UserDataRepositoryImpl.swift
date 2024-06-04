//
//  UserDataRepositoryImpl.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import SwiftUI
import K_Logger
import LocaLocLocalStore
import LocaLocClient

@Observable open class UserDataRepositoryImpl {
    private(set) public var isUserAuthorized: Bool = false
    private(set) public var _currentUser: UserPersistencyModel?
    
    private let client: Client
    private let localStorage: LocalStorage
    
    // MARK: - Init
    public init() throws {
        self.localStorage = try LocalStorage(with: UserPersistencyModel.self, ProfilePersistencyModel.self)
        self.client = Client()
                
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
            Log.error("Local storage setting user data error: \(error)", module: "UserDataRepositoryImpl")
            throw error
        }
    }
    
    private func setUserToClient(_ user: UserPersistencyModel) throws {
        do {
            try client.setUserData(userId: user.id, data: user)

        } catch {
            Log.error("Client setting user data error: \(error)", module: "UserDataRepositoryImpl")
            throw error
        }
    }
    
    private func setCurrentUser(_ user: UserPersistencyModel) {
        self._currentUser = user
        isUserAuthorized = true
    }
    
    private func getClientUserData(userId: String) async throws -> UserPersistencyModel? {
        try await client.userData(userId: userId, type: UserPersistencyModel.self)
    }
    
    private func updateUserData(_ user: UserPersistencyModel, shouldUpdateClient: Bool) throws {
        try setUserToLocalStorage(user)
        
        if shouldUpdateClient {
            try setUserToClient(user)
        }
        
        setCurrentUser(user)
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
            Log.error("User data update error: \(error)", module: "UserDataRepositoryImpl")
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
            Log.error("Authorized user data setting failed", module: "UserDataRepositoryImpl")
            throw error
        }
    }
}

fileprivate extension String {
    static let currentUserIdKey = "current_user_id"
}
