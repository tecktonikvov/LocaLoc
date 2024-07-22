//
//  InvitationClientModel.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import Foundation

public struct InvitationClientModel: Codable {
    public init(
        createdAt: Date,
        usedAt: Date?,
        creatorId: String,
        channelId: String
    ) {
        self.createdAt = createdAt
        self.usedAt = usedAt
        self.creatorId = creatorId
        self.channelId = channelId
    }
    
    public let createdAt: Date
    public let usedAt: Date?
    public let creatorId: String
    public let channelId: String
}
