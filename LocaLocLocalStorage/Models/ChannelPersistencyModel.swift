//
//  ChannelPersistencyModel.swift
//  LocaLocDataRepository
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import SwiftData
import Foundation

@Model
public final class ChannelPersistencyModel {
    public var channelId: String
    public var identifier: String
    public var ownerId: String
    public var name: String
    public var channelDescription: String
    public var imageUrl: URL?
    public var missedUpdatesNumber: Int
    public var creationDate: Date?
    public var lastUpdateTime: Date?
    
    @Relationship(deleteRule: .cascade)
    public var channelSettings: ChannelSettingsPersistencyModel?
    
    @Relationship(deleteRule: .cascade)
    public var channelUserSettings: ChannelUserSettingsPersistencyModel?
    
    public init(
        channelId: String,
        identifier: String,
        ownerId: String,
        name: String,
        channelDescription: String,
        imageUrl: URL?,
        missedUpdatesNumber: Int,
        creationDate: Date?,
        lastUpdateDate: Date?,
        channelSettings: ChannelSettingsPersistencyModel?,
        channelUserSettings: ChannelUserSettingsPersistencyModel?
    ) {
        self.channelId = channelId
        self.identifier = identifier
        self.ownerId = ownerId
        self.name = name
        self.channelDescription = channelDescription
        self.imageUrl = imageUrl
        self.missedUpdatesNumber = missedUpdatesNumber
        self.creationDate = creationDate
        self.lastUpdateTime = lastUpdateDate
        self.channelSettings = channelSettings
        self.channelUserSettings = channelUserSettings
    }
}
