//
//  ChannelPoint.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 9/7/24.
//

import Foundation

@Observable final class ChannelPoint: Equatable {
    static func == (lhs: ChannelPoint, rhs: ChannelPoint) -> Bool {
        lhs.id == rhs.id
    }
    
    public init(id: String, channelId: String, latitude: Double, longitude: Double, address: String, description: String, creatorId: String, createdAt: Date, updatedAt: Date, heading: Double, lifeTime: Int?, emojiCode: String?, isHidden: Bool) {
        self.id = id
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
    
    let id: String
    let channelId: String
    let latitude: Double
    let longitude: Double
    var address: String
    var description: String
    let creatorId: String
    let createdAt: Date
    let updatedAt: Date
    var heading: Double
    var lifeTime: Int?
    var emojiCode: String?
    var isHidden: Bool
}
