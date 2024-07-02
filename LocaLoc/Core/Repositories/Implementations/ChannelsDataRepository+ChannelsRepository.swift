//
//  ChannelsDataRepository+ChannelsRepository.swift
//  LocaLocDataRepository
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import SwiftUI
import K_Logger
import LocaLocClient
import LocaLocLocalStore

fileprivate struct ChannelsDataRepositoryModel {
    let businessModel: Channel
}

@Observable class ChannelsDataRepository {
    var channels: [Channel] = []
    
    let localStorage: LocalStorage
    let channelsClient: ChannelsClient
    
    // MARK: - Init
    init(localStorage: LocalStorage) throws {
        self.channelsClient = ChannelsClient()
        self.localStorage = localStorage
        
        try loadLocalChannels()
        
        #warning("Debug code")
        //deleteAllLocalCachedChannels()
    }
    
    private func deleteAllLocalCachedChannels() {
        let channelsLocalStoreModels = try! localStorage.fetchModelsWith(model: ChannelPersistencyModel.self)
        channelsLocalStoreModels.forEach {
            localStorage.delete(model: $0)
        }
        
        try? reloadChannels()
    }
    
    // MARK: - Private
    private func loadLocalChannels() throws {
        let channelsLocalModels = try localStorage.fetchModelsWith(model: ChannelPersistencyModel.self)
        let channels = channelsLocalModels.compactMap { Channel(persistencyModel: $0) }
        self.channels = channels
    }
    
    private func reloadChannels() throws {
        try loadLocalChannels()
    }
    
    private func saveChannelToClient(_ channel: Channel) async throws {
        let clientModel = ChannelClientModel(channelModel: channel)
        try await channelsClient.saveChanel(channelClientModel: clientModel)
    }
    
    private func makeChannelLocalStorageModel(_ channel: Channel) -> ChannelPersistencyModel {
        let channelPersistencyModel = ChannelPersistencyModel(
            identifier: channel.identifier,
            name: channel.name,
            channelDescription: channel.description, 
            imageUrl: channel.imageUrl,
            missedUpdatesNumber: channel.missedUpdatesNumber,
            creationDate: channel.creationDate,
            lastUpdateDate: channel.lastUpdateDate,
            channelSettings: nil,
            channelUserSettings: nil
        )
        
        let channelSettingsPersistencyModel = ChannelSettingsPersistencyModel(
            invitationMode: channel.channelSettings.invitationMode.rawValue,
            channel: channelPersistencyModel
        )
        
        let channelUserSettings = ChannelUserSettingsPersistencyModel(
            channelUserSettingsModel: channel.userSettings,
            channel: channelPersistencyModel
        )
        
        channelPersistencyModel.channelUserSettings = channelUserSettings
        channelPersistencyModel.channelSettings = channelSettingsPersistencyModel
        
        return channelPersistencyModel
    }
    
    private func saveChannelToLocalStorage(_ channel: Channel) throws {
        let storageModel = makeChannelLocalStorageModel(channel)
        localStorage.addModel(model: storageModel)
    }
}

// MARK: - ChannelsRepository
extension ChannelsDataRepository: ChannelsRepository {
    func saveChannel(_ channel: Channel) async throws {
        try await saveChannelToClient(channel)
        try saveChannelToLocalStorage(channel)
                
        try reloadChannels()
    }
}
