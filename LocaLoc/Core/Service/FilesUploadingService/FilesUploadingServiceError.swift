//
//  FilesUploadingServiceError.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/6/24.
//

import Foundation

enum FilesUploadingServiceError: Error {
    case imageDataGettingError
    case currentUserIsMissed
    case cantResizeImage
}
