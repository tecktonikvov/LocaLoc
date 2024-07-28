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
    public var creationDate: Date?
    public var lastUpdateTime: Date?
    public var invitationMode: String
    
    public init(
        channelId: String,
        identifier: String,
        ownerId: String,
        name: String,
        channelDescription: String,
        imageUrl: URL?,
        creationDate: Date?,
        lastUpdateDate: Date?,
        invitationMode: String
    ) {
        self.channelId = channelId
        self.identifier = identifier
        self.ownerId = ownerId
        self.name = name
        self.channelDescription = channelDescription
        self.imageUrl = imageUrl
        self.creationDate = creationDate
        self.lastUpdateTime = lastUpdateDate
        self.invitationMode = invitationMode
    }
}
