//
//  UserClientModel.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 9/6/24.
//

import Foundation

public struct UserClientModel: Codable {
    public init(id: String, authenticationProviderType: String, firstName: String, lastName: String, email: String, imageUrl: String, username: String) {
        self.id = id
        self.authenticationProviderType = authenticationProviderType
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.imageUrl = imageUrl
        self.username = username
    }
    
    public let id: String
    public let authenticationProviderType: String
    public let firstName: String
    public let lastName: String
    public let email: String
    public let imageUrl: String
    public let username: String
}
