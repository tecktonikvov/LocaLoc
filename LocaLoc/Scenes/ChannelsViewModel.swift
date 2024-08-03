//
//  ChannelsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import Factory
import Foundation
import K_Logger

@Observable final class ChannelsViewModel {
    @ObservationIgnored
    @Injected(\.channelsRepository) private var channelsRepository
    
    @ObservationIgnored
    @Injected(\.channelsClient) private var channelsClient
    
    @ObservationIgnored
    @Injected(\.channelPointsClient) private var channelPointsClient
    
    @ObservationIgnored
    @Injected(\.userIdProvider) private var userIdProvider
    
    @ObservationIgnored
    private var fetchChannelsTask: Task<(), any Error>?
    
    private var fetchedChannels: [Channel] = []
    
    private(set) var showLoadingIndicator = false
    
    private var channelSubscriptionRelations: [String: UserChannelSubscriptionRelationType] = [:]
    
    var searchText = "" {
        didSet {
            if isInSearch {
                fetchChannels()
            }
        }
    }
    
    var channels: [Channel] {
        if isInSearch {
            return fetchedChannels
        } else {
            return channelsRepository.channels
        }
    }
    
    private var isInSearch: Bool {
        searchText.count > 2
    }
    
    // MARK: - Private
    private func cancelFetchChannelsTaskIfNeeded() {
        guard fetchChannelsTask != nil else { return }
        fetchChannelsTask?.cancel()
        fetchChannelsTask = nil
    }

    // MARK: - Public
    func synchronizeUserChannelsList(showLoadingIndicator: Bool) {
        if showLoadingIndicator {
            self.showLoadingIndicator = true
        }
        
        Task { @MainActor in
            do {
                try await channelsRepository.synchronizeUserChannelsList()
            } catch {
                print("🔴", error)
            }
            
            if showLoadingIndicator {
                self.showLoadingIndicator = false
            }
        }
    }
    
    func fetchChannels() {
        cancelFetchChannelsTaskIfNeeded()
        
        fetchChannelsTask = Task { @MainActor in
            try await Task.sleep(nanoseconds: 0.5.nanoseconds)
            
            guard !Task.isCancelled else { return }

            let fetchedChannelsDictionary = try await channelsClient.channels(searchString: searchText)
            
            guard !Task.isCancelled else { return }
            
            var fetchedChannels = [Channel]()
            
            for (id, channelClientModel) in fetchedChannelsDictionary {
                fetchedChannels.append(
                    Channel(clientModel: channelClientModel, id: id)
                )
            }
                        
            guard !Task.isCancelled else { return }
            
            self.fetchedChannels = fetchedChannels
        }
    }
    
    func channelSubscriptionRelation(channelId: String) async -> UserChannelSubscriptionRelationType? {
        if let cachedRelation = channelSubscriptionRelations[channelId] {
            return cachedRelation
        } else if channelsRepository.channels.contains(where: { $0.id == channelId }) {
            return .subscribed
        } else {
            do {
                let userId = try userIdProvider.userId()
                let userChannelsIds = try await channelsClient.userChannelsIds(userId: userId)
                
                if userChannelsIds.contains(channelId) {
                    return .subscribed
                } else {
                    return .notSubscribed
                }
            } catch {
                print("🔴", error)
                Log.error("Channel subscription relation determining error: \(error)", module: "ChannelsViewModel")
                return nil
            }
        }
    }
    
    func channelSubscribersNumber(channelId: String) async -> Int {
        (try? await channelsClient.channelParticipantsNumber(channelId: channelId)) ?? 0
    }
    
    func channelPointsNumber(channelId: String) async -> Int {
        (try? await channelPointsClient.channelPointsNumber(channelId: channelId)) ?? 0
    }
}
