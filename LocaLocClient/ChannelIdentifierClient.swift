//
//  ChannelIdentifierClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 28/6/24.
//

import FirebaseFirestore

public final class ChannelIdentifierClient {
    private let client: Client
    private let identifierFieldName = "identifier"
    private let channelsCollection = CollectionsKeys.channelsCollection
    
    // MARK: - Init
    public init() {
        self.client = Client.shared
    }

    public func isIdentifierFree(identifier: String) async throws -> Bool {
        let filter: Filter = .whereField(identifierFieldName, isEqualTo: identifier.lowercased())
        
        let matches = try await client.filteredData(
            filter: filter,
            collectionName: channelsCollection
        )
        
        let fondIdentifiers = matches.compactMap { ($0[identifierFieldName] as? String)?.lowercased() }
        
        return !fondIdentifiers.contains(identifier.lowercased())
    }
}
