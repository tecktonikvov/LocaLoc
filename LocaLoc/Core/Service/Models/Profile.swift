//
//  Profile.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import Observation

@Observable final class Profile {
    var firstName: String
    var lastName: String
    var email: String
    var imageUrl: String
    var username: String
    
    init(firstName: String, lastName: String, email: String, imageUrl: String, username: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.imageUrl = imageUrl
        self.username = username
    }
}
