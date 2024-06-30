//
//  Constants.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/6/24.
//

import Foundation

struct Constants {
    // User constants
    static let usernameCharactersMin: Int = 3
    static let usernameCharactersLimit: Int = 40
    static let firstNameCharactersLimit: Int = 40
    static let lastNameCharactersLimit: Int = 40
    static let userAvatarCompression: Double = 0.6
    static let userAvatarMaxSideSize: CGFloat = 800.0
    static let userAvatarImageFormat: String = ".jpeg"
    
    // Channel constants
    static let channelIdentifierMinCharactersLimit: Int = 3
    static let channelIdentifierMaxCharactersLimit: Int = 40
    static let channelNameCharactersLimit: Int = 72
    static let channelDescriptionCharactersLimit: Int = 255
    static let channelsAvatarCompression: Double = 1.0
    static let channelAvatarImageFormat: String = ".jpeg"
}
