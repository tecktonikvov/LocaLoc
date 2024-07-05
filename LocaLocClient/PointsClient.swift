//
//  PointsClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import Foundation

public final class PointsClient {
    private let client: Client
    private let channelsPointsCollection = CollectionsKeys.channelsPointsCollection
    
    // MARK: - Init
    public init() {
        self.client = Client()
    }

    public func savePoint(pointClientModel: PointClientModel) async throws -> String {
       try await client.setData(
            collectionName: channelsPointsCollection,
            data: pointClientModel)
    }
    
    public func point(withId id: String) async throws -> PointClientModel? {
        try await client.data(documentId: id, collectionName: channelsPointsCollection, type: PointClientModel.self)
    }
    
    public func updateChannel(withId id: String, pointClientModel: PointClientModel) async throws {
        try await client.setData(
            documentId: id,
            collectionName: channelsPointsCollection,
            data: pointClientModel)
    }
}
