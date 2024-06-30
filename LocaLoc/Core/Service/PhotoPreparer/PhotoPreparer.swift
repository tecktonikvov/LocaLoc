//
//  PhotoPreparer.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import UIKit

protocol PhotoPreparer {
    func resizedAndCompressedImage(_ photo: UIImage) async throws -> Data
}

extension PhotoPreparer {
    func resizedAndCompressedImage(_ photo: UIImage) async throws -> Data {
        guard let resizedPhoto = await resize(photo) else {
            throw FilesUploadingServiceError.cantResizeImage
        }
        
        guard let data = resizedPhoto.jpegData(compressionQuality: Constants.userAvatarCompression) else {
            throw FilesUploadingServiceError.imageDataGettingError
        }
        
        return data
    }
    
    // MARK: - Private
    private func resize(_ photo: UIImage) async -> UIImage? {
        let maxSize = Constants.userAvatarMaxSideSize
        
        guard photo.size.width > maxSize || photo.size.height > maxSize else {
            return photo
        }
        
        let resizedPhoto = await photo.resizeWithWidth(width: maxSize)
        
        return resizedPhoto
    }
}
