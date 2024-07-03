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
import SwiftData

enum ChannelsDataRepositoryError: Error {
    case attemptToUpdateChannelWithEmptyId
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
        let channelsLocalStoreModels = try! localStorage.fetchModelsWith(
            model: ChannelPersistencyModel.self,
            descriptor: nil
        )
        
        channelsLocalStoreModels.forEach {
            localStorage.delete(model: $0)
        }
        
        try? reloadChannels()
    }
    
    // MARK: - Private
    private func loadLocalChannels() throws {
        let channelsLocalModels = try localStorage.fetchModelsWith(model: ChannelPersistencyModel.self, descriptor: nil)
        let channels = channelsLocalModels.compactMap { Channel(persistencyModel: $0) }
        self.channels = channels
        Log.info("Loaded \(channels.count) from local storage", module: "ChannelsDataRepository")
    }
    
    private func reloadChannels() throws {
        try loadLocalChannels()
    }
    
    private func saveChannelToClient(_ channel: Channel) async throws -> String {
        let clientModel = ChannelClientModel(channelModel: channel)
        return try await channelsClient.saveChanel(channelClientModel: clientModel)
    }
    
    private func makeChannelLocalStorageModel(_ channel: Channel) -> ChannelPersistencyModel {
        let channelPersistencyModel = ChannelPersistencyModel(
            channelId: channel.id,
            identifier: channel.identifier,
            ownerId: channel.ownerId,
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
    
    private func existingClientChannel(_ channel: Channel) async throws -> ChannelClientModel? {
        let id = channel.id
        
        guard !id.isEmpty else { return nil }
        
        return try await channelsClient.channel(with: channel.id)
    }
    
    private func updateExistingChannel(clientModel: ChannelClientModel, update: Channel) async throws -> Channel {
        let updatedClientModel = ChannelClientModel(channelModel: update)
        try await channelsClient.updateChannel(channelClientModel: updatedClientModel, id: update.id)
        
        if let channelLocalStoreModel = try localStorageClientModel(channelId: update.id) {
            localStorage.delete(model: channelLocalStoreModel)
            
            let newChannelLocalStoreModel = makeChannelLocalStorageModel(update)
            localStorage.addModel(model: newChannelLocalStoreModel)
        }
        
        return update
    }
    
    private func localStorageClientModel(channelId id: String) throws -> ChannelPersistencyModel? {
        let descriptor = FetchDescriptor<ChannelPersistencyModel>(predicate: #Predicate { channelLocalStoreModel in
            channelLocalStoreModel.channelId == id
        })
        
        return try localStorage.fetchModelsWith(
            model: ChannelPersistencyModel.self,
            descriptor: descriptor)
        .first
    }
    
    private func createAndSaveChannel(_ channel: Channel) async throws -> Channel {
        let channelClientId = try await saveChannelToClient(channel)
        channel.id = channelClientId
        
        try saveChannelToLocalStorage(channel)
                        
        return channel
    }
}

// MARK: - ChannelsRepository
extension ChannelsDataRepository: ChannelsRepository {
    func saveChannel(_ channel: Channel) async throws -> Channel {
        let result: Channel
        
        if let existingChannel = try await existingClientChannel(channel) {
            guard !channel.id.isEmpty else {
                throw ChannelsDataRepositoryError.attemptToUpdateChannelWithEmptyId
            }
            
            result = try await updateExistingChannel(clientModel: existingChannel, update: channel)
        } else {
            result = try await createAndSaveChannel(channel)
        }
        
        try reloadChannels()
        return result
    }
    
    func synchronizeChannelsList() async throws {
        // TODO: ...
    }
}
