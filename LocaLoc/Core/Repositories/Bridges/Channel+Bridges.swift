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
            name: persistencyModel.name,
            description: persistencyModel.channelDescription,
            imageUrl: persistencyModel.imageUrl,
            missedUpdatesNumber: persistencyModel.missedUpdatesNumber,
            creationDate: persistencyModel.creationDate,
            lastUpdateDate: persistencyModel.lastUpdateTime,
            channelSettings: channelSettings,
            userSettings: userSettings
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

// MARK: - Client and Business models
extension ChannelClientModel {
    init(channelModel: Channel) {
        self.init(
            identifier: channelModel.identifier,
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
