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
    var isImageSelected: Bool = false
    var identifierErrorText = ""

    // Chanel data
    var name: String = ""
    var description: String = ""
    var identifier: String = ""
    var invitationMode: ChannelInvitationMode = .open
    
    let availableInvitationModes: [ChannelInvitationMode] = [.open, .byInvitation]
    
    private var channelCreationTask: Task<(), Never>?
    
    private let channelPhotoUploader: ChannelPhotoUploader
    private let channelIdentifierChecker: ChannelIdentifierChecker
    
    // MARK: - Init
    init(channelIdentifierChecker: ChannelIdentifierClient, channelPhotoUploader: ChannelPhotoUploader) {
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
    
    
    private func saveChannel(photoUrl: URL?) async throws {
        // ...
    }
    
    // MARK: - Public
    func createChannel() {
        isLoading = true
        
        channelCreationTask = Task {
            do {
                guard try await isIdentifierFree() else {
                    await MainActor.run {
                        isLoading = false
                        identifierErrorText = "Identifier is busy"
                        showAlert = true
                    }
                    return
                }
                
                guard !Task.isCancelled else { return }
                
                var photoUrl: URL?
                
                if isImageSelected {
                    photoUrl = try await uploadChannelPhoto(image)
                }
                
                // TODO: Remove image if cancelled
                guard !Task.isCancelled else { return }
                
                try await saveChannel(photoUrl: photoUrl)
            } catch {
                Log.error("Channel creation request error: \(error)", module: "ChannelCreationViewModel")
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
}
