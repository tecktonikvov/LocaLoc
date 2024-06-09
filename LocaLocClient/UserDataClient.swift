//
//  UserDataClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 4/6/24.
//

import Foundation

public final class UserDataClient {
    private let usersCollection = CollectionsKeys.usersCollection
    
    private let client: Client
    
    // MARK: - Init
    public init(client: Client) {
        self.client = client
    }
    
    // MARK: - Private
    public func setUserData(userId: String, data: UserClientModel) throws {
        Task {
            try await client.setData(documentId: userId, collectionName: usersCollection, data: data)
        }
    }
    
    public func userData(userId: String) async throws -> UserClientModel? {
        try await client.data(documentId: userId, collectionName: usersCollection, type: UserClientModel.self)
    }
}
