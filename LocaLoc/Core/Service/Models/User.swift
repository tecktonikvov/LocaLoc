//
//  User.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import SwiftData

@Model
final class User {
    init(id: String, authenticationProviderType: AuthenticationProviderType?, profile: Profile) {
        self.id = id
        self.profile = profile
        self.authenticationProviderType = authenticationProviderType
    }
    
    let id: String
    var authenticationProviderType: AuthenticationProviderType?
    
    @Relationship(deleteRule: .cascade)
    var profile: Profile
}
