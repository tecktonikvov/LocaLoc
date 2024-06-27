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
        
        let fileName = userId + ".jpeg"
            
        let fileUrl = try await filesUploadingClient.uploadUserAvatar(data, fileName: fileName)
        
        return fileUrl
    }
    
    private func resizedAndCompressedImage(_ photo: UIImage) async throws -> Data {
        guard let resizedPhoto = await resize(photo) else {
            throw FilesUploadingServiceError.cantResizeImage
        }
        
        guard let data = resizedPhoto.jpegData(compressionQuality: Constants.userAvatarCompression) else {
            throw FilesUploadingServiceError.imageDataGettingError
        }
        
        return data
    }
    
    private func resize(_ photo: UIImage) async -> UIImage? {
        let maxSize = Constants.userAvatarMaxSideSize
        
        guard photo.size.width > maxSize || photo.size.height > maxSize else {
            return photo
        }
        
        let resizedPhoto = await photo.resizeWithWidth(width: maxSize)
        
        return resizedPhoto
    }
}

extension UIImage {
    @MainActor
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(
            frame: CGRect(origin: .zero,
                          size: CGSize(width: width,
                                       height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
