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
