//
//  PointClientModel.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import Foundation

public struct PointClientModel: Codable {
    public init(latitude: String, longitude: String, address: String, creatorId: String, createdAt: Data? = nil, updatedAt: Data? = nil, heading: Double, lifeTime: Int? = nil, emoji: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.creatorId = creatorId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.heading = heading
        self.lifeTime = lifeTime
        self.emoji = emoji
    }
    
    public let latitude: String
    public let longitude: String
    public let address: String
    public let creatorId: String
    public let createdAt: Data?
    public let updatedAt: Data?
    public let heading: Double
    public let lifeTime: Int?
    public let emoji: String?
}
