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

extension UserPersistencyModel: Codable {
    enum CodingKeys: CodingKey {
        case id, authenticationProviderType, profile
    }
    
    public convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let authenticationProviderType = try container.decode(AuthenticationProviderTypePersistencyModel.self, forKey: .authenticationProviderType)
        let profile = try container.decode(ProfilePersistencyModel.self, forKey: .profile)
        
        self.init(id: id, authenticationProviderType: authenticationProviderType, profile: profile)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(authenticationProviderType, forKey: .authenticationProviderType)
        try container.encode(profile, forKey: .profile)
    }
}
