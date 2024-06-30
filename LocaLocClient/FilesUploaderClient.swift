//
//  FilesUploaderClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 26/6/24.
//

import Foundation

enum FileContentType: String {
    case jpeg = "image/jpeg"
}

enum Folder: String {
    case userAvatars
    case channelsAvatars
}

public class FilesUploaderClient {
    private let client: Client
    
    // MARK: - Init
    public init(client: Client) {
        self.client = client
    }

    // MARK: - Public
    public func uploadUserAvatar(_ data: Data, fileName: String) async throws -> URL {
        try await client.uploadData(
            data,
            folderName: Folder.userAvatars.rawValue,
            fileName: fileName,
            contentType: FileContentType.jpeg
        )
    }
    
    public func uploadChannelAvatar(_ data: Data, fileName: String) async throws -> URL {
        try await client.uploadData(
            data,
            folderName: Folder.channelsAvatars.rawValue,
            fileName: fileName,
            contentType: FileContentType.jpeg
        )
    }
}
