//
//  ChannelCreationViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 25/5/24.
//

import UIKit
import Foundation
import LocaLocClient
import K_Logger

@Observable final class ChannelCreationViewModel {
    var image = UIImage() {
        didSet {
            DispatchQueue.main.async {
                self.isImageSelected = true
            }
        }
    }
    
    var isLoading = false
    var showAlert = false
    var dismiss = false
    var isImageSelected = false
    var identifierErrorText = ""

    // Chanel data
    var name: String = ""
    var description: String = ""
    var identifier: String = ""
    var invitationMode: ChannelInvitationMode = .open
    
    let availableInvitationModes: [ChannelInvitationMode] = [.open, .byInvitation]
    
    private var channelCreationTask: Task<(), Never>?
    
    // Dependencies
    private let channelsRepository: ChannelsRepository
    private let channelPhotoUploader: ChannelPhotoUploader
    private let channelIdentifierChecker: ChannelIdentifierChecker

    // MARK: - Init
    init(channelIdentifierChecker: ChannelIdentifierClient, channelPhotoUploader: ChannelPhotoUploader, channelsRepository: ChannelsRepository) {
        self.channelsRepository = channelsRepository
        self.channelPhotoUploader = channelPhotoUploader
        self.channelIdentifierChecker = channelIdentifierChecker
    }
    
    // MARK: - Private
    private func isIdentifierFree() async throws -> Bool {
        let isFree = try await channelIdentifierChecker.isIdentifierFree(identifier)
        return isFree
    }
    
    private func uploadChannelPhoto(_ photo: UIImage) async throws -> URL {
        let fileUrl = try await channelPhotoUploader.uploadChannelPhoto(photo)
        return fileUrl
    }
    
    private func makeChannel(photoUrl: URL?) -> Channel {
        Channel(
            identifier: identifier,
            name: name,
            description: description,
            imageUrl: photoUrl,
            missedUpdatesNumber: 0, 
            creationDate: nil,
            lastUpdateDate: nil,
            channelSettings: ChannelSettings(invitationMode: invitationMode),
            userSettings: .default
        )
    }
    
    private func saveChannel(photoUrl: URL?) async throws {
        let channel = makeChannel(photoUrl: photoUrl)
        try await channelsRepository.saveChannel(channel)
    }
    
    // MARK: - Public
    func createChannel() {
        isLoading = true
        
        channelCreationTask = Task { @MainActor in
            do {
                guard try await isIdentifierFree() else {
                    isLoading = false
                    identifierErrorText = "Identifier is busy"
                    showAlert = true
                    return
                }
                
                guard !Task.isCancelled else { return }
                
                var photoUrl: URL?
                
                if isImageSelected {
                    photoUrl = try await uploadChannelPhoto(image)
                }
                
                guard !Task.isCancelled else {
                    // TODO: Delete uploaded image if cancelled
                    return
                }
                
                try await saveChannel(photoUrl: photoUrl)
                
                dismiss = true
            } catch {
                Log.error("Channel creation request error: \(error)", module: "ChannelCreationViewModel")
            }
            
            isLoading = false
        }
    }
}
