//
//  ChannelPointsClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import FirebaseFirestore

public final class ChannelPointsClient {
    private let client: Client
    private let channelsPointsCollection = CollectionsKeys.channelsPointsCollection
    private let channelsPointModelChannelIdFieldName = "channelId"
    
    // MARK: - Init
    public init() {
        self.client = Client.shared
    }

    public func savePoint(pointClientModel: ChannelPointClientModel) async throws -> String {
       try await client.setData(
            collectionName: channelsPointsCollection,
            data: pointClientModel)
    }
    
    public func point(withId id: String) async throws -> ChannelPointClientModel? {
        try await client.data(documentId: id, collectionName: channelsPointsCollection, type: ChannelPointClientModel.self)
    }
    
    public func updatePoint(withId id: String, pointClientModel: ChannelPointClientModel) async throws {
        try await client.setData(
            documentId: id,
            collectionName: channelsPointsCollection,
            data: pointClientModel)
    }
    
    public func pointsIds(forChannelWithId channelId: String) async throws -> [String] {
        let filter: Filter = .whereField(channelsPointModelChannelIdFieldName, isEqualTo: channelId)
        
        let documents = try await client.documents(
            filter: filter,
            collectionName: channelsPointsCollection
        )
        
        return documents.map { $0.documentID }
    }
    
    public func channelPointsNumber(channelId: String) async throws -> Int {
        let filter: Filter = .whereField(channelsPointModelChannelIdFieldName, isEqualTo: channelId)
        return try await client.count(filter: filter, collectionName: channelsPointsCollection)
    }
    
    public func delete(pointWithId id: String) async throws {
        try await client.delete(documentId: id, collectionName: channelsPointsCollection)
    }
    
    public func deleteChannelPoints(channelId: String) async throws {
        let filter: Filter = .whereField(
            channelsPointModelChannelIdFieldName,
            isEqualTo: channelId
        )
        
        let pointsDocuments = try await client.documents(
            filter: filter,
            collectionName: channelsPointsCollection
        )
        
        try await withThrowingTaskGroup(of: Void.self) { taskGroup in    
            let channelsPointsCollection = channelsPointsCollection
            
            for pointDocument in pointsDocuments {
                taskGroup.addTask { [weak self] in
                    try await self?.client.delete(
                        documentId: pointDocument.documentID,
                        collectionName: channelsPointsCollection
                    )
                }
            }
            
            try await taskGroup.waitForAll()
        }
    }
}
