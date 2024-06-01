//
//  DataRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import SwiftUI
import SwiftData

@Observable final class UserDataRepository {
    private let modelContext: ModelContext
    
    private(set) var currentUser: User?
    private(set) var userAuthenticationStatus: UserAuthenticationStatus = .unauthorized
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        if let currentUserId = UserDefaults.standard.string(forKey: .currentUserIdKey),
           let currentUser = retrieveUser(with: currentUserId) {
            self.currentUser = currentUser
            self.userAuthenticationStatus = .authorized
        } else {
            self.userAuthenticationStatus = .unauthorized
        }
    }
    
    private func retrieveUser(with id: String) -> User? {
        var descriptor = FetchDescriptor<User>(predicate: #Predicate { user in
            user.id == id
        })
        
        descriptor.fetchLimit = 1
        
        do {
            let fetchResult = try modelContext.fetch(descriptor).first
            return fetchResult
        } catch {
            print("🔴", error)
            return nil
        }
    }

    func clearCurrentUserData() {
        UserDefaults.standard.removeObject(forKey: .currentUserIdKey)
        currentUser = nil
        userAuthenticationStatus = .unauthorized
    }
    
    func setAuthorizedUser(_ user: User) {
        UserDefaults.standard.set(user.id, forKey: .currentUserIdKey)
        self.currentUser = user

        if let existingUser = retrieveUser(with: user.id) {
            modelContext.delete(existingUser)
        }
    
        modelContext.insert(user)
        
        userAuthenticationStatus = .authorized
    }
}

fileprivate extension String {
    static let currentUserIdKey = "current_user_id"
}
