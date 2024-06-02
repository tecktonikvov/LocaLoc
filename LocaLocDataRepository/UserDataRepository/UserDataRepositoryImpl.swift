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
    private(set) public var _currentUser: UserPersistencyModel?
    private(set) public var isUserAuthorized: Bool = false
    
    private let localStorage: LocalStorage
    private let client: Client
    
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

    // MARK: - Public
    public func clearCurrentUserData() {
        UserDefaults.standard.removeObject(forKey: .currentUserIdKey)
        _currentUser = nil
        isUserAuthorized = false
    }
    
    public func setAuthorizedUser(_ user: UserPersistencyModel) {
        let userId = user.id
        
        UserDefaults.standard.set(userId, forKey: .currentUserIdKey)
        self._currentUser = user
        
        client.setUserData(userId: userId, data: user)
        
        do {
            if let existingUser = try storedUser(with: user.id) {
                localStorage.delete(model: existingUser)
            }
        } catch {
            Log.error("Authorization user setup error: \(error)", module: "UserDataRepositoryImpl")
        }
    
        localStorage.addModel(model: user)
        
        isUserAuthorized = true
    }
}

fileprivate extension String {
    static let currentUserIdKey = "current_user_id"
}
