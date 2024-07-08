//
//  UserDataRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftUI

protocol UserDataRepository: Observable {
    var currentUser: User? { get }
    var userAuthenticationStatus: UserAuthenticationStatus { get }
    func removeCurrentUserData()
    func setAuthorizedUser(_ authorizationUserData: AuthorizationUserData) async throws
    func updateUser(_ user: User) async throws
}
