//
//  UserAuthenticationStatus.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import Foundation

enum UserAuthenticationStatus: String, Codable {
    case unauthorized
    case authorized
    case noUsername
}
