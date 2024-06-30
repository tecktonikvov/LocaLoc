//
//  FilesUploadingService+UserPhotoUploader.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/6/24.
//

import UIKit
import LocaLocClient

extension FilesUploadingService: UserPhotoUploader {
    func uploadUserPhoto(_ photo: UIImage) async throws -> URL {
        let data = try await resizedAndCompressedImage(photo)
        
        guard let userId = userDataRepository.currentUser?.id else {
            throw FilesUploadingServiceError.currentUserIsMissed
        }
        
        let fileName = userId + Constants.userAvatarImageFormat
            
        let fileUrl = try await filesUploadingClient.uploadUserAvatar(data, fileName: fileName)
        
        return fileUrl
    }
}
