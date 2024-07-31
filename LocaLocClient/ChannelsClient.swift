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
    private let channelsParticipantsModelUserIdFieldName = "userId"
    private let channelsParticipantsModelChannelIdFieldName = "channelId"
    private let channelsModelSegmentsFieldName = "searchSegments"

    // MARK: - Init
    public init() {
        self.client = Client.shared
    }

    public func saveChanel(channelClientModel: ChannelClientModel) async throws -> String {
       try await client.setData(
            collectionName: channelsCollection,
            data: channelClientModel)
    }
    
    public func channel(withId id: String) async throws -> ChannelClientModel? {
        try await client.data(
            documentId: id,
            collectionName: channelsCollection,
            type: ChannelClientModel.self)
    }
    
    public func updateChannel(withId id: String, channelClientModel: ChannelClientModel) async throws {
        try await client.setData(
            documentId: id,
            collectionName: channelsCollection,
            data: channelClientModel)
    }
    
    public func createChannelParticipant(channelParticipantClientModel: ChannelParticipantClientModel) async throws {
        let _ = try await client.setData(
            collectionName: channelsParticipantsCollection,
            data: channelParticipantClientModel
        )
    }
    
    public func channelParticipantsNumber(channelId: String) async throws -> Int {
        let filter: Filter = .whereField(channelsParticipantsModelChannelIdFieldName, isEqualTo: channelId)
        return try await client.count(filter: filter, collectionName: channelsParticipantsCollection)
    }
    
    public func deleteChannelParticipants(channelId: String) async throws {
        let filter: Filter = .whereField(
            channelsParticipantsModelChannelIdFieldName,
            isEqualTo: channelId
        )
        
        let participantsDocuments = try await client.documents(
            filter: filter,
            collectionName: channelsParticipantsCollection
        )
        
        try await withThrowingTaskGroup(of: Void.self) { taskGroup in   
            let channelsParticipantsCollection = channelsParticipantsCollection
            
            for participantsDocument in participantsDocuments {
                taskGroup.addTask { [weak self] in
                    try await self?.client.delete(
                        documentId: participantsDocument.documentID,
                        collectionName: channelsParticipantsCollection
                    )
                }
            }
            
            try await taskGroup.waitForAll()
        }
    }
    
    public func deleteChannelParticipant(channelId: String, participantId: String) async throws {
        let channelIdFilter: Filter = .whereField(
            channelsParticipantsModelChannelIdFieldName,
            isEqualTo: channelId
        )
        
        let participantIdFilter: Filter = .whereField(
            channelsParticipantsModelUserIdFieldName,
            isEqualTo: participantId
        )
        
        let filter: Filter = .andFilter([channelIdFilter, participantIdFilter])
        
        let participantDocument = try await client.documents(
            filter: filter,
            collectionName: channelsParticipantsCollection
        ).first
        
        if let participantDocument {
            try await client.delete(
                documentId: participantDocument.documentID,
                collectionName: channelsParticipantsCollection
            )
        }
    }
    
    public func userChannelsIds(userId: String) async throws -> [String] {
        let filter: Filter = .whereField(channelsParticipantsModelUserIdFieldName, isEqualTo: userId)
        
        let documents = try await client.documents(
            filter: filter,
            collectionName: channelsParticipantsCollection
        )
        
        return documents.compactMap {
            $0.data()[channelsParticipantsModelChannelIdFieldName] as? String
        }
    }
    
    public func deleteChannel(channelId: String) async throws {
        try await client.delete(documentId: channelId, collectionName: channelsCollection)
    }
    
    public func channels(searchString: String) async throws -> [String: ChannelClientModel] {
        let filter: Filter = .whereField(
            channelsModelSegmentsFieldName,
            arrayContains: searchString.lowercased()
        )
                
        let dictionary = try await client.objects(
            collectionName: channelsCollection,
            filter: filter,
            type: ChannelClientModel.self
        )
        
       return dictionary
    }
    
    /// Legacy
//    public func channels(searchString: String) async throws -> [String: ChannelClientModel] {
//        let strEnd = "\(searchString.lowercased())\u{f7ff}"
//        let setStart = searchString.lowercased()
//
//        let nameSubFilter1: Filter = .whereField(
//            channelsModelSearchableChannelNameFieldName,
//            isGreaterOrEqualTo: setStart
//        )
//
//        let nameSubFilter2: Filter = .whereField(
//            channelsModelSearchableChannelNameFieldName,
//            isLessThan: strEnd
//        )
//
//        let nameFilter: Filter = .andFilter([nameSubFilter1, nameSubFilter2])
//
//        let descriptionSubFilter1: Filter = .whereField(
//            channelsModelSearchableChannelDescriptionFieldName,
//            isGreaterOrEqualTo: setStart
//        )
//
//        let descriptionSubFilter2: Filter = .whereField(
//            channelsModelSearchableChannelDescriptionFieldName,
//            isLessThan: strEnd
//        )
//
//        let descriptionFilter: Filter = .andFilter([descriptionSubFilter1, descriptionSubFilter2])
//
//        let filter: Filter = .orFilter([nameFilter, descriptionFilter])
//
//        let dictionary = try await client.objects(
//            collectionName: channelsCollection,
//            filter: filter,
//            type: ChannelClientModel.self
//        )
//
//       return dictionary
//    }
}
