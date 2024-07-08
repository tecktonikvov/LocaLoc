//
//   UserDataDataRepositoryImpl+UserIdProvider.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 8/7/24.
//

import Foundation

enum UserIdProviderError: Error {
    case userIsNotAuthenticated
}

// MARK: UserIdProvider
extension UserDataDataRepository: UserIdProvider {
    func userId() throws -> String {
        if let currentUser {
            return currentUser.id
        } else {
            throw UserIdProviderError.userIsNotAuthenticated
        }
    }
}
