//
//  ChannelIdentifierClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 28/6/24.
//

import FirebaseFirestore

public final class ChannelIdentifierClient {
    private let channelsCollection = CollectionsKeys.channelsCollection
    private let identifierFieldName = "identifier"
    private let client: Client
    
    // MARK: - Init
    public init() {
        self.client = Client()
    }

    public func isIdentifierFree(identifier: String) async throws -> Bool {
        let filter: Filter = .whereField(identifierFieldName, isEqualTo: identifier)
        
        let matches = try await client.filteredData(
            filter: filter,
            collectionName: channelsCollection
        )
        
        return matches.isEmpty
    }
}
