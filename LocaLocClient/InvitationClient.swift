//
//  InvitationClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import FirebaseFirestore

public final class InvitationClient {
    private let client: Client
    private let invitationsCollection = CollectionsKeys.invitationsCollection
    
    // MARK: - Init
    public init() {
        self.client = Client.shared
    }

    public func saveInvitation(_ clientModel: InvitationClientModel) async throws -> String {
       try await client.setData(
            collectionName: invitationsCollection,
            data: clientModel)
    }
    
    public func invitation(withId id: String) async throws -> InvitationClientModel? {
        try await client.data(
            documentId: id,
            collectionName: invitationsCollection,
            type: InvitationClientModel.self)
    }
    
    public func updateInvitation(id: String, invitationClientModel: InvitationClientModel) async throws {
        try await client.setData(
            documentId: id,
            collectionName: invitationsCollection,
            data: invitationClientModel)
    }
}
