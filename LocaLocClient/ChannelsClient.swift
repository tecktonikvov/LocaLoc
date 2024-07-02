//
//  ChannelsClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 1/7/24.
//

import FirebaseFirestore

public final class ChannelsClient {
    private let client: Client
    private let channelsCollection = CollectionsKeys.channelsCollection
    
    // MARK: - Init
    public init() {
        self.client = Client()
    }

    public func saveChanel(channelClientModel: ChannelClientModel) async throws -> String {
       try await client.setData(
            collectionName: channelsCollection,
            data: channelClientModel)
    }
    
    public func channel(with id: String) async throws -> ChannelClientModel? {
        try await client.data(documentId: id, collectionName: channelsCollection, type: ChannelClientModel.self)
    }
    
    public func updateChannel(channelClientModel: ChannelClientModel, id: String) async throws {
        try await client.setData(
            documentId: id,
            collectionName: channelsCollection,
            data: channelClientModel)
    }
}
