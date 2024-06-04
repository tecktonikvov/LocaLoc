//
//  UserDataClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 4/6/24.
//

import Foundation

public final class UserDataClient: Client {
    private let usersCollection = CollectionsKeys.usersCollection
    
    // MARK: - Private
    public func setUserData(userId: String, data: Encodable) throws {
        Task {
            try await setData(documentId: userId, collectionName: usersCollection, data: data)
        }
    }
    
    public func userData<T: Decodable>(userId: String, type: T.Type) async throws -> T? {
       try await data(documentId: userId, collectionName: usersCollection, type: type)
    }
}
