//
//  UserPersistencyModel.swift
//  DataRepository
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftData
import Foundation

@Model
public final class UserPersistencyModel {
    public let id: String
    public var authenticationProviderType: AuthenticationProviderTypePersistencyModel?
    
    public let createdAt: Date
    public var updatedAt: Date
    
    @Relationship(deleteRule: .cascade)
    public var profile: ProfilePersistencyModel
    
    public init(
        id: String,
        authenticationProviderType: AuthenticationProviderTypePersistencyModel?,
        profile: ProfilePersistencyModel,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.profile = profile
        self.authenticationProviderType = authenticationProviderType
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension UserPersistencyModel: Codable {
    enum CodingKeys: CodingKey {
        case id, authenticationProviderType, profile, createdAt, updatedAt
    }
    
    public convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let authenticationProviderType = try container.decode(AuthenticationProviderTypePersistencyModel.self, forKey: .authenticationProviderType)
        let profile = try container.decode(ProfilePersistencyModel.self, forKey: .profile)
        let createdAt = try container.decode(Date.self, forKey: .createdAt)
        let updatedAt = try container.decode(Date.self, forKey: .updatedAt)

        self.init(
            id: id,
            authenticationProviderType: authenticationProviderType,
            profile: profile,
            createdAt: createdAt, 
            updatedAt: updatedAt
        )
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(authenticationProviderType, forKey: .authenticationProviderType)
        try container.encode(profile, forKey: .profile)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
