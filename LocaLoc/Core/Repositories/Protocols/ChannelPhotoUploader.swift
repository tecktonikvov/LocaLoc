//
//  ChannelPhotoUploader.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import UIKit

protocol ChannelPhotoUploader {
    func uploadChannelPhoto(_ photo: UIImage) async throws -> URL
}
