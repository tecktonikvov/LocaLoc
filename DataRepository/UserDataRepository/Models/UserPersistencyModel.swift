//
//  UserPersistencyModel.swift
//  DataRepository
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftData

@Model
public final class UserPersistencyModel {
    public let id: String
    public var authenticationProviderType: AuthenticationProviderTypePersistencyModel?
    
    @Relationship(deleteRule: .cascade)
    public var profile: ProfilePersistencyModel
    
    public init(id: String, authenticationProviderType: AuthenticationProviderTypePersistencyModel?, profile: ProfilePersistencyModel) {
        self.id = id
        self.profile = profile
        self.authenticationProviderType = authenticationProviderType
    }
}
