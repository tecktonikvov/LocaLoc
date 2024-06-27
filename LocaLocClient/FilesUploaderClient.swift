//
//  FilesUploaderClient.swift
//  LocaLocClient
//
//  Created by Volodymyr Kotsiubenko on 26/6/24.
//

import Foundation

public class FilesUploaderClient {
    public enum Folder: String {
        case userAvatars
        case channelsAvatars
    }
    
    private let client: Client
    
    // MARK: - Init
    public init(client: Client) {
        self.client = client
    }

    // MARK: - Public
    public func uploadUserAvatar(_ data: Data, fileName: String) async throws -> URL {
        try await client.uploadData(data, folderName: Folder.userAvatars.rawValue, fileName: fileName)
    }
}
