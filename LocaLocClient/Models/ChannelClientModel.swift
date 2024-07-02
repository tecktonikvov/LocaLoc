//
//  ChannelClientModel.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 1/7/24.
//

import Foundation

public struct ChannelClientModel: Codable {
    public init(identifier: String, name: String, description: String, imageUrl: URL?, missedUpdatesNumber: Int, creationDate: Date?, lastUpdateDate: Date?, channelInvitationMode: String) {
        self.identifier = identifier.lowercased()
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.missedUpdatesNumber = missedUpdatesNumber
        self.creationDate = creationDate
        self.lastUpdateDate = lastUpdateDate
        self.channelInvitationMode = channelInvitationMode
    }
    
    public let identifier: String
    public let name: String
    public let description: String
    public let imageUrl: URL?
    public let missedUpdatesNumber: Int
    public let creationDate: Date?
    public let lastUpdateDate: Date?
    public let channelInvitationMode: String
}
