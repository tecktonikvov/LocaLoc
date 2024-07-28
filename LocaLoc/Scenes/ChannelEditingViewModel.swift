//
//  ChannelEditingViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 28/7/24.
//

import UIKit
import K_Logger
import Factory
import SDWebImageSwiftUI

@Observable final class ChannelEditingViewModel {
    var image: UIImage? {
        didSet {
            guard image != nil else { return }
            isImageChanged = true
        }
    }
    
    var isLoading = false
    var showAlert = false
    var dismiss = false
    var isImageChanged = false
    var identifierErrorText = ""

    // Chanel data
    var name: String
    var description: String
    var identifier: String
    var invitationMode: ChannelInvitationMode

    let availableInvitationModes = ChannelInvitationMode.allCases
    
    private var channelEditingTask: Task<(), Never>?
    
    private let channel: Channel
    private let initialIdentifier: String

    // Dependencies
    @ObservationIgnored
    @Injected(\.channelsRepository) private var channelsRepository
    @ObservationIgnored
    @Injected(\.channelPhotoUploader) private var channelPhotoUploader
    @ObservationIgnored
    @Injected(\.channelIdentifierChecker) private var channelIdentifierChecker
    
    // MARK: - Init
    init(channel: Channel) {
        self.channel = channel
        self.name = channel.name
        self.description = channel.description
        self.identifier = channel.identifier
        self.invitationMode = channel.invitationMode
        self.initialIdentifier = channel.identifier

        if let imageUrl = channel.imageUrl {
            SDWebImageManager().loadImage(with: imageUrl, progress: nil) { uIImage, _, _, _, _, _ in
                self.image = uIImage
                self.isImageChanged = false
            }
        }
    }
    
    // MARK: - Private
    private func isIdentifierFree() async throws -> Bool {
        let isFree = try await channelIdentifierChecker.isIdentifierFree(identifier)
        return isFree
    }
    
    // TODO: Remove old one image
    private func replaceChannelPhoto(_ photo: UIImage, channelId: String) async throws -> URL {
        let fileUrl = try await channelPhotoUploader.uploadChannelPhoto(photo, channelId: channelId)
        return fileUrl
    }
    
    // MARK: - Public
    func createChannel() {
        isLoading = true
        
        channelEditingTask = Task { @MainActor in
            do {
                let isIdentifierChanged = initialIdentifier != identifier
                
                if isIdentifierChanged {
                    guard try await isIdentifierFree() else {
                        isLoading = false
                        identifierErrorText = "Identifier is busy"
                        showAlert = true
                        return
                    }
                }
                
                guard !Task.isCancelled else { return }
                                                
                if let image, isImageChanged {
                    let imageUrl = try await replaceChannelPhoto(image, channelId: channel.id)
                    channel.imageUrl = imageUrl
                }
                
                channel.name = name
                channel.description = description
                channel.identifier = identifier
                channel.invitationMode = invitationMode

                try await channelsRepository.saveChannel(channel)
                
                dismiss = true
            } catch {
                Log.error("Channel edit request error: \(error)", module: "ChannelEditingViewModel")
            }
            
            isLoading = false
        }
    }
}
