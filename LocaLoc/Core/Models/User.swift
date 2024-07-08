//
//  User.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import Foundation

@Observable final class User {
    let id: String
    
    var authenticationProviderType: AuthenticationProviderType?
    var profile: Profile
    var createdAt: Date
    var updatedAt: Date
    
    init(id: String, authenticationProviderType: AuthenticationProviderType?, profile: Profile, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.profile = profile
        self.authenticationProviderType = authenticationProviderType
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
