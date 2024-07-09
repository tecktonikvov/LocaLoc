//
//  ChannelParticipantModel.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 4/7/24.
//

import Foundation

public struct ChannelParticipantClientModel: Codable {
    public init(id: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public let id: String
    public let createdAt: Date
    public let updatedAt: Date
}
