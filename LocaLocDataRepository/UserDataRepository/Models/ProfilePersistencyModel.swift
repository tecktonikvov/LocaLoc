//
//  ProfilePersistencyModel.swift
//  DataRepository
//
//  Created by Volodymyr Kotsiubenko on 1/6/24.
//

import SwiftData

@Model
public final class ProfilePersistencyModel {
    public var firstName: String
    public var lastName: String
    public var email: String
    public var imageUrl: String
    public var username: String
    
    public init(firstName: String, lastName: String, email: String, imageUrl: String, username: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.imageUrl = imageUrl
        self.username = username
    }
}

extension ProfilePersistencyModel: Codable {
    enum CodingKeys: CodingKey {
        case firstName, lastName, email, imageUrl, username
    }
    
    public convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        let email = try container.decode(String.self, forKey: .email)
        let imageUrl = try container.decode(String.self, forKey: .imageUrl)
        let username = try container.decode(String.self, forKey: .username)

        self.init(
            firstName: firstName,
            lastName: lastName,
            email: email,
            imageUrl: imageUrl,
            username: username
        )
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(username, forKey: .username)
    }
}
