//
//  FilesUploadingService.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 26/6/24.
//

import LocaLocClient

final class FilesUploadingService {
    let userDataRepository: UserDataRepository
    let filesUploadingClient: FilesUploaderClient

    init(userDataRepository: UserDataRepository) {
        let client = Client()
        
        self.userDataRepository = userDataRepository
        self.filesUploadingClient = FilesUploaderClient(client: client)
    }
}
