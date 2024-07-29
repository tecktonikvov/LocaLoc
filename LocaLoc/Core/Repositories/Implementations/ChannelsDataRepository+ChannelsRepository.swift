//
//  ChannelsDataRepository+ChannelsRepository.swift
//  LocaLocDataRepository
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import Factory
import SwiftUI
import K_Logger
import SwiftData
import LocaLocClient
import LocaLocLocalStore

enum ChannelsDataRepositoryError: Error {
    case attemptToUpdateChannelWithEmptyId
}

@Observable class ChannelsDataRepository {
    var channels: [Channel] = []
        
    private let localStorage: LocalStorage
    private let channelsClient: ChannelsClient
    
    @ObservationIgnored
    @Injected(\.userIdProvider) private var userIdProvider
    
    // MARK: - Init
    init(localStorage: LocalStorage) throws {
        self.channelsClient = ChannelsClient()
        self.localStorage = localStorage
        
        try loadLocalStoreChannels()
        
        //deleteAllLocalCachedChannels()
    }
    
    // MARK: - Private
    private func deleteAllLocalCachedChannels() {
        try? localStorage.deleteAllModels(withTypes: ChannelPersistencyModel.self)
        try? reloadLocalStoreChannels()
    }
    
    private func loadLocalStoreChannels() throws {
        let channelsLocalModels = try localStorage.fetchModelsWith(model: ChannelPersistencyModel.self, descriptor: nil)
        let channels = channelsLocalModels.compactMap { Channel(persistencyModel: $0) }
        self.channels = channels
        Log.info("Loaded \(channels.count) channels from local storage", module: "ChannelsDataRepository")
    }
    
    private func reloadLocalStoreChannels() throws {
        try loadLocalStoreChannels()
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
            creationDate: channel.creationDate,
            lastUpdateDate: channel.lastUpdateDate,
            invitationMode: channel.invitationMode.rawValue
        )
        
        return channelPersistencyModel
    }
    
    private func saveChannelToLocalStorage(_ channel: Channel) throws {
        let storageModel = makeChannelLocalStorageModel(channel)
        localStorage.addModel(model: storageModel)
    }
    
    private func existingClientChannelModel(_ channel: Channel) async throws -> ChannelClientModel? {
        let id = channel.id
        
        guard !id.isEmpty else { return nil }
        
        return try await channelsClient.channel(withId: channel.id)
    }
    
    private func updateExistingChannel(update: Channel) async throws -> Channel {
        let updatedClientModel = ChannelClientModel(channelModel: update)
        try await channelsClient.updateChannel(withId: update.id, channelClientModel: updatedClientModel)
        
        try updateLocalModel(with: update)
        
        return update
    }
    
    private func updateLocalModel(with channelModel: Channel) throws {
        guard let channelLocalStoreModel = try localStorageChannelModel(channelId: channelModel.id) else { return }
        
        channelLocalStoreModel.channelDescription = channelModel.description
        channelLocalStoreModel.identifier = channelModel.identifier
        channelLocalStoreModel.imageUrl = channelModel.imageUrl
        channelLocalStoreModel.lastUpdateTime = channelModel.lastUpdateDate
        channelLocalStoreModel.name = channelModel.name
        channelLocalStoreModel.ownerId = channelModel.ownerId
        channelLocalStoreModel.channelId = channelModel.id
        channelLocalStoreModel.invitationMode = channelModel.invitationMode.rawValue
    }
    
    private func localStorageChannelModel(channelId id: String) throws -> ChannelPersistencyModel? {
        let predicate = #Predicate<ChannelPersistencyModel> { $0.channelId == id }
        let descriptor = FetchDescriptor<ChannelPersistencyModel>(predicate: predicate)
        
        return try localStorage.fetchModelsWith(
            model: ChannelPersistencyModel.self,
            descriptor: descriptor)
        .first
    }
    
    private func addOwnerToChannelParticipantsList(channel: Channel) async throws {
        let ownerModel = ChannelParticipantClientModel(
            userId: channel.ownerId,
            channelId: channel.id,
            createdAt: Date.timeZoneIndependentCurrentDate,
            updatedAt: Date.timeZoneIndependentCurrentDate
        )
        
        try await channelsClient.createChannelParticipant(channelParticipantClientModel: ownerModel)
    }
    
    private func createAndSaveChannel(_ channel: Channel) async throws -> Channel {
        let channelClientId = try await saveChannelToClient(channel)
        channel.id = channelClientId
        
        try await addOwnerToChannelParticipantsList(channel: channel)
        
        try saveChannelToLocalStorage(channel)
                        
        return channel
    }
    
    private func makeChannelLocalStoreModel(channelId: String, clientModel: ChannelClientModel) -> ChannelPersistencyModel {
        let channelLocalStorageModel = ChannelPersistencyModel(
            channelId: channelId,
            identifier: clientModel.identifier,
            ownerId: clientModel.ownerId,
            name: clientModel.name,
            channelDescription: clientModel.description,
            imageUrl: clientModel.imageUrl,
            creationDate: clientModel.createdAt,
            lastUpdateDate: clientModel.updatedAt, 
            invitationMode: clientModel.channelInvitationMode
        )
        
        return channelLocalStorageModel
    }
    
    private func channels(withIds ids: [String]) async throws -> [ChannelPersistencyModel] {
        guard !ids.isEmpty else { return [] }

        let channels = try await withThrowingTaskGroup(of: ChannelPersistencyModel?.self, returning: [ChannelPersistencyModel?].self) { taskGroup in
            for id in ids {
                taskGroup.addTask { [weak self] in
                    guard let self,
                          let clientModel = try await channelsClient.channel(withId: id) else {
                        return nil
                    }
                    
                   return makeChannelLocalStoreModel(channelId: id, clientModel: clientModel)
                }
            }

            var channels = [ChannelPersistencyModel?]()

            while let fetchedChannel = try await taskGroup.next() {
                channels.append(fetchedChannel)
            }
            
            return channels
        }
        
        return channels.compactMap { $0 }
    }
}

extension ChannelsDataRepository: ChannelsRepository {
    func cleanChannelsList() {
        channels = []
    }
    
    func saveChannel(_ channel: Channel) async throws -> Channel {
        let result: Channel
        
        channel.lastUpdateDate = Date.timeZoneIndependentCurrentDate
        
        let isChannelExists = try await existingClientChannelModel(channel) != nil
        
        if isChannelExists {
            guard !channel.id.isEmpty else {
                throw ChannelsDataRepositoryError.attemptToUpdateChannelWithEmptyId
            }
            
            result = try await updateExistingChannel(update: channel)
        } else {
            result = try await createAndSaveChannel(channel)
        }
        
        try await synchronizeUserChannelsList()
        return result
    }
    
    func synchronizeUserChannelsList() async throws {
        Log.info("Channels list synchronization started", module: "ChannelsDataRepository")
        
        let userId = try userIdProvider.userId()
        let channelsIds = try await channelsClient.userChannelsIds(userId: userId)

        // Delete cached channels
        try localStorage.deleteAllModels(withTypes: ChannelPersistencyModel.self)
        
        // Add actual models
        let channelsLocalStoreModels = try await channels(withIds: channelsIds)
        
        for channelLocalStoreModel in channelsLocalStoreModels {
            localStorage.addModel(model: channelLocalStoreModel)
        }
        
        try reloadLocalStoreChannels()
        
        Log.info("Channels list synchronization finished. Fetched \(channels.count) channels", module: "ChannelsDataRepository")
    }
    
    func fetchChannel(withId channelId: String) async throws -> Channel? {
        guard let clientModel = try await channelsClient.channel(withId: channelId) else {
            return nil
        }
        
        let channelModel = Channel(clientModel: clientModel, id: channelId)
        
        return channelModel
    }
    
    func subscribersNumber(channelId: String) -> Int? {
        guard let channelsSubscribersNumbers = UserDefaults.standard.value(forKey: .channelsSubscribersNumbers),
              var dictionary = channelsSubscribersNumbers as? [String: Int] else {
            return nil
        }
        
        return dictionary[channelId]
    }
    
    func saveSubscribersNumber(forChannelWithId channelId: String, number: Int) {
        if let channelsSubscribersNumbers = UserDefaults.standard.value(forKey: .channelsSubscribersNumbers),
           var dictionary = channelsSubscribersNumbers as? [String: Int] {
            dictionary[channelId] = number
            UserDefaults.standard.setValue(dictionary, forKey: .channelsSubscribersNumbers)
        } else {
            let dictionary = [channelId: number]
            UserDefaults.standard.setValue(dictionary, forKey: .channelsSubscribersNumbers)
        }
    }
}

// MARK: String+currentUserIdKey
fileprivate extension String {
    static let channelsSubscribersNumbers = "channelsSubscribersNumbers"
}
