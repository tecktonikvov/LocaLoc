//
//  User.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import Observation

@Observable final class User {
    let id: String
    
    var authenticationProviderType: AuthenticationProviderType?
    var profile: Profile
    
    init(id: String, authenticationProviderType: AuthenticationProviderType?, profile: Profile) {
        self.id = id
        self.profile = profile
        self.authenticationProviderType = authenticationProviderType
    }
}
