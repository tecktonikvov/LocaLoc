//
//  ChannelCreationViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 25/5/24.
//

import UIKit
import K_Logger
import Factory

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
    @ObservationIgnored
    @Injected(\.channelsRepository) private var channelsRepository
    @ObservationIgnored
    @Injected(\.userDataRepository) private var userDataRepository
    @ObservationIgnored
    @Injected(\.channelPhotoUploader) private var channelPhotoUploader
    @ObservationIgnored
    @Injected(\.channelIdentifierChecker) private var channelIdentifierChecker
    
    // MARK: - Private
    private func isIdentifierFree() async throws -> Bool {
        let isFree = try await channelIdentifierChecker.isIdentifierFree(identifier)
        return isFree
    }
    
    private func uploadChannelPhoto(_ photo: UIImage, channelId: String) async throws -> URL {
        let fileUrl = try await channelPhotoUploader.uploadChannelPhoto(photo, channelId: channelId)
        return fileUrl
    }
    
    private func makeChannelEmpty() -> Channel {
        Channel(
            id: "",
            identifier: identifier, 
            ownerId: userDataRepository.currentUser?.id ?? "",
            name: name,
            description: description,
            imageUrl: nil,
            missedUpdatesNumber: 0,
            creationDate: nil,
            lastUpdateDate: nil,
            channelSettings: ChannelSettings(invitationMode: invitationMode),
            userSettings: .default
        )
    }
    
    private func createEmptyChannelAndSave() async throws -> Channel {
        let channel = makeChannelEmpty()
        return try await channelsRepository.saveChannel(channel)
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
                
                let newChannel = try await createEmptyChannelAndSave()
                
                guard !Task.isCancelled else { 
                    // TODO: Delete uploaded image if cancelled
                    return
                }
                                                
                if isImageSelected {
                    let imageUrl = try await uploadChannelPhoto(image, channelId: newChannel.id)
                    newChannel.imageUrl = imageUrl
                    
                }
                
                try await channelsRepository.saveChannel(newChannel)
                
                dismiss = true
            } catch {
                Log.error("Channel creation request error: \(error)", module: "ChannelCreationViewModel")
            }
            
            isLoading = false
        }
    }
}
