//
//  ChannelParticipantModel.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 4/7/24.
//

import Foundation

public struct ChannelParticipantClientModel: Codable {
    public init(userId: String ,channelId: String, createdAt: Date, updatedAt: Date) {
        self.userId = userId
        self.channelId = channelId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public let userId: String
    public let channelId: String
    public let createdAt: Date
    public let updatedAt: Date
}
