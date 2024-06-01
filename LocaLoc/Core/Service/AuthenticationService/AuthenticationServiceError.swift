//
//  AuthenticationServiceError.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import Foundation

enum AuthenticationServiceError: Error {
    case googleIdTokenIsNil
    case userIdIsNil
}
