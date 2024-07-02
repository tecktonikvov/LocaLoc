//
//  UserNameClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 4/6/24.
//

import FirebaseFirestore

public final class UserNameClient {
    private let usersCollection = CollectionsKeys.usersCollection
    private let usernameFieldName = "username"
    private let client: Client
    
    // MARK: - Init
    public init(client: Client) {
        self.client = client
    }

    public func isUsernameFree(username: String) async throws -> Bool {
        let lowercased = username.lowercased()
        let filter: Filter = .whereField(usernameFieldName, isEqualTo: lowercased)
        
        let matches = try await client.filteredData(
            filter: filter,
            collectionName: usersCollection
        )
        
        let fondIdentifiers = matches.compactMap { ($0[usernameFieldName] as? String)?.lowercased() }
        
        return !fondIdentifiers.contains(lowercased)
    }
    
    public func set(username: String, userId: String) async throws {
        try await client.updateData(in: usersCollection, for: userId, data: [usernameFieldName: username])
    }
}
