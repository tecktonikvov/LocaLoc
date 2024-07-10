//
//  ChannelPointClientModel.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import Foundation

public struct ChannelPointClientModel: Codable {
    public init(channelId: String, latitude: Double, longitude: Double, address: String, description: String, creatorId: String, createdAt: Date, updatedAt: Date, heading: Double, lifeTime: Int?, emojiCode: String?, isHidden: Bool) {
        self.channelId = channelId
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.description = description
        self.creatorId = creatorId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.heading = heading
        self.lifeTime = lifeTime
        self.emojiCode = emojiCode
        self.isHidden = isHidden
    }
    
    public let channelId: String
    public let latitude: Double
    public let longitude: Double
    public let address: String
    public let description: String
    public let creatorId: String
    public let createdAt: Date
    public let updatedAt: Date
    public let heading: Double
    public let lifeTime: Int?
    public let emojiCode: String?
    public let isHidden: Bool
}
