//
//  ChannelDetailsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import Foundation
import Factory
import SwiftUI
import K_Logger

enum ChannelDetailsViewModelError: Error {
    case noPermission
}

struct ChannelDetailsModel: Equatable, Hashable {
    let channel: Channel
    let pointsNumber: Int
    let participantsNumber: Int
    let isChannelOwner: Bool
    let isSubscribed: Bool
}

enum ShareItemType {
    case free(shareItem: ShareItem)
    case invitation(shareItem: ShareItem)
}

@Observable final class ChannelDetailsViewModel {
    @ObservationIgnored
    @Injected(\.userIdProvider) private var userIdProvider
    
    @ObservationIgnored
    @Injected(\.channelsClient) private var channelsClient
    
    @ObservationIgnored
    @Injected(\.channelPointsClient) private var channelPointsClient
    
    @ObservationIgnored
    @Injected(\.channelsRepository) private var channelsRepository
    
    private(set) var shareItemType: ShareItemType?
    private(set) var channelModel: ChannelDetailsModel
    
    var showDeleteConfirmationPopUp = false
    var showLeaveConfirmationPopUp = false

    // MARK: - Init
    init(channelDetailsModel: ChannelDetailsModel) {
        self.channelModel = channelDetailsModel
        setShareItem()
    }
    
    // MARK: - Private
    private func setShareItem() {
        let invitationMode = channelModel.channel.invitationMode
        guard let url = URL(string: "localocapp://channel?identifier=QEqgSzGPu5Kk2kcQcRBA") else {
            return
        }
        
        switch invitationMode {
        case .open:
            let item = ShareItem(
                image: Image("share_sheet_icon_1"),
                title: "Channel link",
                link: url)
            
            shareItemType = .free(shareItem: item)
        case .byInvitation:
            if channelModel.isChannelOwner {
                let item = ShareItem(
                    image: Image("share_sheet_icon_1"),
                    title: "Channel invite",
                    link: url)
                
                shareItemType = .invitation(shareItem: item)
            } else {
                let item = ShareItem(
                    image: Image("share_sheet_icon_1"),
                    title: "Channel link",
                    link: url)
                
                shareItemType = .free(shareItem: item)
            }
        }
    }
    
    private func deleteClientChannelMembersModels() async throws {
        try await channelsClient.deleteChannelParticipants(channelId: channelModel.channel.id)
    }
    
    private func deleteClientChannelPointsModels() async throws {
        try await channelPointsClient.deleteChannelPoints(channelId: channelModel.channel.id)
    }
    
    private func deleteClientChannelModel() async throws {
        try await channelsClient.deleteChannel(channelId: channelModel.channel.id)
    }
    
    private func deleteMemberFormClientModels() async throws {
        let userId = try userIdProvider.userId()
        try await channelsClient.deleteChannelParticipant(channelId: channelModel.channel.id, participantId: userId)
    }
    
    // MARK: - Public
    func userTappedDeleteLeaveButton() {
        guard channelModel.isChannelOwner else { return }
        showDeleteConfirmationPopUp = true
    }
    
    func deleteChannel() async throws {
        do {
            guard channelModel.isChannelOwner else {
                throw ChannelDetailsViewModelError.noPermission
            }
            
            try await deleteClientChannelModel()
            try await deleteClientChannelMembersModels()
            try await deleteClientChannelPointsModels()
            try await channelsRepository.synchronizeUserChannelsList()
        } catch {
            print("🔴", error)
            Log.error("Channel deleting error occurred:\(error)", module: "ChannelDetailsViewModel")
            throw error
        }
    }
    
    func deleteChannelCanceled() {
        showDeleteConfirmationPopUp = false
    }
    
    func userTappedLeaveButton() {
        showLeaveConfirmationPopUp = true
    }
    
    func leaveChannel() async throws {
        do {
            try await deleteMemberFormClientModels()
            try await channelsRepository.synchronizeUserChannelsList()
        } catch {
            print("🔴", error)
            Log.error("Leaving error occurred:\(error)", module: "ChannelDetailsViewModel")
            throw error
        }
    }
    
    func leaveChannelCanceled() {
        showLeaveConfirmationPopUp = false
    }
}
