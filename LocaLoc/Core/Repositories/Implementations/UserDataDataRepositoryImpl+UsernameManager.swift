//
//   UserDataDataRepositoryImpl+UsernameManager.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 8/7/24.
//

import K_Logger
import Foundation

extension UserDataDataRepository: UsernameManager {
    func setUserName(_ username: String) async throws {
        do {
            guard let currentUser else {
                throw UserDataDataRepositoryError.currentUserIsMissed
            }
            
            let currentUserCopy = User(
                id: currentUser.id,
                authenticationProviderType: currentUser.authenticationProviderType,
                profile: currentUser.profile,
                createdAt: currentUser.createdAt,
                updatedAt: currentUser.updatedAt
            )
                        
            currentUserCopy.profile.username = username.lowercased()
            
            try await setUserData(currentUserCopy, shouldUpdateClient: true)
        } catch {
            Log.error("User name set request error: \(error)", module: "UserDataDataRepository")
            throw error
        }
    }
    
    func isUsernameFree(_ username: String) async throws -> Bool {
        do {
            return try await userNameClient.isUsernameFree(username: username)
        } catch {
            Log.error("Is username free request error: \(error)", module: "UserDataDataRepository")
            return false
        }
    }
}

