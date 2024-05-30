//
//  Profile.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 24/5/24.
//

import Foundation

struct Profile: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var imageUrl: String
    var username: String
    
    var fullName: String {
        firstName + " " + lastName
    }
}
