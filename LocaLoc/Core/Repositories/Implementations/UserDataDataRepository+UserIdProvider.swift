//
//  UserDataDataRepository+UserIdProvider.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/7/24.
//

import LocaLocDataRepository

extension UserDataDataRepository: UserIdProvider {
    func userId() throws -> String {
        if let currentUser {
            return currentUser.id
        } else {
            throw UserIdProviderError.userIsNotAuthenticated
        }
    }
}
