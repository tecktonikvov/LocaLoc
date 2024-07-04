//
//  UserIdProvider.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/7/24.
//

import Foundation

enum UserIdProviderError: Error {
    case userIsNotAuthenticated
}

protocol UserIdProvider {
    func userId() throws -> String
}
