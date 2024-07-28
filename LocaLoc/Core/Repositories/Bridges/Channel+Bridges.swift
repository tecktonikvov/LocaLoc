//
//  Channel+Bridges.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 1/7/24.
//

import LocaLocClient
import LocaLocLocalStore

// MARK: - LocalStore and Business models
extension Channel {
    convenience init(persistencyModel: ChannelPersistencyModel) {
        self.init(
            id: persistencyModel.channelId,
            identifier: persistencyModel.identifier, 
            ownerId: persistencyModel.ownerId,
            name: persistencyModel.name,
            description: persistencyModel.channelDescription,
            imageUrl: persistencyModel.imageUrl,
            creationDate: persistencyModel.creationDate,
            lastUpdateDate: persistencyModel.lastUpdateTime,
            invitationMode: ChannelInvitationMode(rawValue: persistencyModel.invitationMode) ?? .open
        )
    }
    
    convenience init(clientModel: ChannelClientModel, id: String) {
        self.init(
            id: id,
            identifier: clientModel.identifier,
            ownerId: clientModel.ownerId,
            name: clientModel.name,
            description: clientModel.description,
            imageUrl: clientModel.imageUrl,
            creationDate: clientModel.createdAt,
            lastUpdateDate: clientModel.updatedAt,
            invitationMode: ChannelInvitationMode(rawValue: clientModel.channelInvitationMode) ?? .open
        )
    }
}

extension ChannelPersistencyModel {
    /// Waring: channelSettings and channelUserSettings will be always nil
    convenience init(channelModel: Channel) {
        self.init(
            channelId: channelModel.id,
            identifier: channelModel.identifier,
            ownerId: channelModel.ownerId,
            name: channelModel.name,
            channelDescription: channelModel.description, 
            imageUrl: channelModel.imageUrl,
            creationDate: channelModel.creationDate,
            lastUpdateDate: channelModel.lastUpdateDate,
            invitationMode: channelModel.invitationMode.rawValue
        )
    }
}

extension ChannelPoint {
    convenience init(channelPointPersistencyModel: ChannelPointPersistencyModel) {
        self.init(
            id: channelPointPersistencyModel.id, 
            channelId: channelPointPersistencyModel.channelId,
            latitude: channelPointPersistencyModel.latitude,
            longitude: channelPointPersistencyModel.longitude,
            address: channelPointPersistencyModel.address, 
            description: channelPointPersistencyModel._description,
            creatorId: channelPointPersistencyModel.creatorId,
            createdAt: channelPointPersistencyModel.createdAt,
            updatedAt: channelPointPersistencyModel.updatedAt,
            heading: channelPointPersistencyModel.heading,
            lifeTime: channelPointPersistencyModel.lifeTime,
            emojiCode: channelPointPersistencyModel.emojiCode,
            isHidden: channelPointPersistencyModel.isHidden
        )
    }
}

extension ChannelPointPersistencyModel {
    convenience init(channelPointModel: ChannelPoint) {
        self.init(
            id: channelPointModel.id,
            channelId: channelPointModel.channelId,
            latitude: channelPointModel.latitude,
            longitude: channelPointModel.longitude,
            address: channelPointModel.address, 
            description: channelPointModel.description,
            creatorId: channelPointModel.creatorId,
            createdAt: channelPointModel.createdAt,
            updatedAt: channelPointModel.updatedAt,
            heading: channelPointModel.heading,
            lifeTime: channelPointModel.lifeTime,
            emojiCode: channelPointModel.emojiCode,
            isHidden: channelPointModel.isHidden
        )
    }
    
    convenience init(channelClientModel: ChannelPointClientModel, id: String) {
        self.init(
            id: id,
            channelId: channelClientModel.channelId,
            latitude: channelClientModel.latitude,
            longitude: channelClientModel.longitude,
            address: channelClientModel.address,
            description: channelClientModel.description,
            creatorId: channelClientModel.creatorId,
            createdAt: channelClientModel.createdAt,
            updatedAt: channelClientModel.updatedAt,
            heading: channelClientModel.heading,
            lifeTime: channelClientModel.lifeTime,
            emojiCode: channelClientModel.emojiCode,
            isHidden: channelClientModel.isHidden
        )
    }
}

// MARK: - Client and Business models
extension ChannelClientModel {
    init(channelModel: Channel) {
        self.init(
            identifier: channelModel.identifier, 
            ownerId: channelModel.ownerId,
            name: channelModel.name,
            description: channelModel.description,
            imageUrl: channelModel.imageUrl,
            creationDate: channelModel.creationDate,
            lastUpdateDate: channelModel.lastUpdateDate,
            channelInvitationMode: channelModel.invitationMode.rawValue
        )
    }
}

extension ChannelPoint {
    convenience init(channelPointClientModel: ChannelPointClientModel, id: String) {
        self.init(
            id: id,
            channelId: channelPointClientModel.channelId,
            latitude: channelPointClientModel.latitude,
            longitude: channelPointClientModel.longitude,
            address: channelPointClientModel.address,
            description: channelPointClientModel.description,
            creatorId: channelPointClientModel.creatorId,
            createdAt: channelPointClientModel.createdAt,
            updatedAt: channelPointClientModel.updatedAt,
            heading: channelPointClientModel.heading,
            lifeTime: channelPointClientModel.lifeTime,
            emojiCode: channelPointClientModel.emojiCode,
            isHidden: channelPointClientModel.isHidden
        )
    }
}

extension ChannelPointClientModel {
    init(channelPointModel: ChannelPoint) {
        self.init(
            channelId: channelPointModel.channelId,
            latitude: channelPointModel.latitude,
            longitude: channelPointModel.longitude,
            address: channelPointModel.address, 
            description: channelPointModel.description,
            creatorId: channelPointModel.creatorId,
            createdAt: channelPointModel.createdAt,
            updatedAt: channelPointModel.updatedAt,
            heading: channelPointModel.heading,
            lifeTime: channelPointModel.lifeTime,
            emojiCode: channelPointModel.emojiCode,
            isHidden: channelPointModel.isHidden
        )
    }
}
