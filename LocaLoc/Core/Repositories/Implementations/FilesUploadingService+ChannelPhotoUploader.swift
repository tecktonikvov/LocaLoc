//
//  FilesUploadingService+ChannelPhotoUploader.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import UIKit

extension FilesUploadingService: ChannelPhotoUploader {
    func uploadChannelPhoto(_ photo: UIImage, channelId: String) async throws -> URL {
        let data = try await resizedAndCompressedImage(photo)
        
        let fileName = channelId + Constants.channelAvatarImageFormat
            
        let fileUrl = try await filesUploadingClient.uploadChannelAvatar(data, fileName: fileName)
        
        return fileUrl
    }
}
