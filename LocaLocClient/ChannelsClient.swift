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
    private let channelsParticipantsCollection = CollectionsKeys.channelsParticipants
    private let channelsParticipantsModelIdFieldName = "id"
    
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
    
    public func createChannelParticipantsList(channelId: String, owner: ChannelParticipantModel) async throws {
        try await client.setData(
            documentId: channelId,
            collectionName: channelsParticipantsCollection,
            data: owner)
    }
    
    public func userChannelsIds(userId: String) async throws -> [String] {
        let filter: Filter = .whereField(channelsParticipantsModelIdFieldName, isEqualTo: userId)
        
        let documents = try await client.documents(
            filter: filter,
            collectionName: channelsParticipantsCollection
        )
        
        return documents.map { $0.documentID }
    }
}
