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

    public func saveChanel(channelClientModel: ChannelClientModel) async throws {
       try await client.setData(
            documentId: channelClientModel.identifier,
            collectionName: channelsCollection,
            data: channelClientModel)
    }
}
