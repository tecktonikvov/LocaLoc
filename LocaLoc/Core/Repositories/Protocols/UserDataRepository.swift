//
//  UserDataRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import Observation

protocol UserDataRepository: Observable {
    var currentUser: User? { get }
    var userAuthenticationStatus: UserAuthenticationStatus { get }
    func clearCurrentUserData()
    func setAuthorizedUser(_ authorizationUserData: AuthorizationUserData) throws
    func updateCurrentUser(_ user: User) throws
}
