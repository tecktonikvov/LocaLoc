//
//  UserPhotoUploader.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/6/24.
//

import UIKit

protocol UserPhotoUploader {
    func uploadUserPhoto(_ photo: UIImage) async throws -> URL
}
