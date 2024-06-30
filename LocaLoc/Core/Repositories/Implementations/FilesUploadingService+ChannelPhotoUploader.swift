//
//  FilesUploadingService+ChannelPhotoUploader.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import UIKit

extension FilesUploadingService: ChannelPhotoUploader {
    func uploadChannelPhoto(_ photo: UIImage) async throws -> URL {
        let data = try await resizedAndCompressedImage(photo)
        
        guard let userId = userDataRepository.currentUser?.id else {
            throw FilesUploadingServiceError.currentUserIsMissed
        }
        
        let fileName = userId + Constants.channelAvatarImageFormat
            
        let fileUrl = try await filesUploadingClient.uploadChannelAvatar(data, fileName: fileName)
        
        return fileUrl
    }
}
