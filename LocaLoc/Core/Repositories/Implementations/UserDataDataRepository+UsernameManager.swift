//
//  UserDataDataRepository+UsernameManager.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/6/24.
//

import LocaLocDataRepository

extension UserDataDataRepository: UsernameManager {
    func setUserName(_ username: String) async throws {
        try await set(username: username)
    }
    
    func isUsernameFree(_ username: String) async throws -> Bool {
        try await isUsernameFree(username: username)
    }
}
