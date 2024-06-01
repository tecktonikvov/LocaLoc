//
//  UserDataRepositoryImpl.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import SwiftUI
import SwiftData
import K_Logger

@Observable open class UserDataRepositoryImpl: DataRepository {
    private(set) public var _currentUser: UserPersistencyModel?
    private(set) public var isUserAuthorized: Bool = false
    
    public override init() throws {
        try super.init()
        
        if let currentUserId = UserDefaults.standard.string(forKey: .currentUserIdKey),
           let currentUser = try retrieveUser(with: currentUserId) {
            self._currentUser = currentUser
            self.isUserAuthorized = true
        }
    }
    
    private func retrieveUser(with id: String) throws -> UserPersistencyModel? {
        var descriptor = FetchDescriptor<UserPersistencyModel>(predicate: #Predicate { user in
            user.id == id
        })
        
        descriptor.fetchLimit = 1
        
        let fetchResult = try modelContext.fetch(descriptor).first
        return fetchResult
    }

    public func clearCurrentUserData() {
        UserDefaults.standard.removeObject(forKey: .currentUserIdKey)
        _currentUser = nil
        isUserAuthorized = false
    }
    
    public func setAuthorizedUser(_ user: UserPersistencyModel) {
        UserDefaults.standard.set(user.id, forKey: .currentUserIdKey)
        self._currentUser = user

        do {
            if let existingUser = try retrieveUser(with: user.id) {
                modelContext.delete(existingUser)
            }
        } catch {
            Log.error("Authorization user setup error: \(error)", module: "UserDataRepositoryImpl")
        }
    
        modelContext.insert(user)
        
        isUserAuthorized = true
    }
}

fileprivate extension String {
    static let currentUserIdKey = "current_user_id"
}
