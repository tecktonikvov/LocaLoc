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
    convenience init?(persistencyModel: ChannelPersistencyModel) {
        guard let channelSettings = ChannelSettings(persistencyModel: persistencyModel.channelSettings) else {
            return nil
        }
        
        let userSettings = ChannelUserSettings(persistencyModel: persistencyModel.channelUserSettings) ?? .default
        
        self.init(
            id: persistencyModel.channelId,
            identifier: persistencyModel.identifier, 
            ownerId: persistencyModel.ownerId,
            name: persistencyModel.name,
            description: persistencyModel.channelDescription,
            imageUrl: persistencyModel.imageUrl,
            missedUpdatesNumber: persistencyModel.missedUpdatesNumber,
            creationDate: persistencyModel.creationDate,
            lastUpdateDate: persistencyModel.lastUpdateTime,
            channelSettings: channelSettings,
            userSettings: userSettings, 
            channelPoints: []
        )
    }
    
    convenience init?(clientModel: ChannelClientModel, id: String) {
        guard let invitationMode = ChannelInvitationMode(rawValue: clientModel.channelInvitationMode) else {
            return nil
        }
        
        let channelSettings = ChannelSettings(invitationMode: invitationMode)
        let userSettings = ChannelUserSettings(isMuted: false)
        
        self.init(
            id: id,
            identifier: clientModel.identifier,
            ownerId: clientModel.ownerId,
            name: clientModel.name,
            description: clientModel.description,
            imageUrl: clientModel.imageUrl,
            missedUpdatesNumber: clientModel.missedUpdatesNumber,
            creationDate: clientModel.createdAt,
            lastUpdateDate: clientModel.updatedAt,
            channelSettings: channelSettings,
            userSettings: userSettings,
            channelPoints: []
        )
    }
}

extension ChannelSettings {
    convenience init?(persistencyModel: ChannelSettingsPersistencyModel?) {
        guard let persistencyModel,
            let object = ChannelInvitationMode(rawValue: persistencyModel.invitationMode) else {
            return nil
        }
        
        self.init(invitationMode: object)
    }
}

extension ChannelUserSettings {
    convenience init?(persistencyModel: ChannelUserSettingsPersistencyModel?) {
        guard let persistencyModel else {
            return nil
        }
        
        self.init(isMuted: persistencyModel.isMuted)
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
            missedUpdatesNumber: channelModel.missedUpdatesNumber,
            creationDate: channelModel.creationDate,
            lastUpdateDate: channelModel.lastUpdateDate,
            channelSettings: nil,
            channelUserSettings: nil
        )
    }
}

extension ChannelSettingsPersistencyModel {
    convenience init(channelSettingsModel: ChannelSettings, channel: ChannelPersistencyModel) {
        self.init(invitationMode: channelSettingsModel.invitationMode.rawValue, channel: channel)
    }
}

extension ChannelUserSettingsPersistencyModel {
    convenience init(channelUserSettingsModel: ChannelUserSettings, channel: ChannelPersistencyModel) {
        self.init(isMuted: channelUserSettingsModel.isMuted, channel: channel)
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
            missedUpdatesNumber: channelModel.missedUpdatesNumber,
            creationDate: channelModel.creationDate,
            lastUpdateDate: channelModel.lastUpdateDate,
            channelInvitationMode: channelModel.channelSettings.invitationMode.rawValue
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
