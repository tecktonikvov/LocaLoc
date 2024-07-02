//
//  ChannelsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import Observation
import LocaLocClient
import LocaLocDataRepository

@Observable final class ChannelsViewModel {
    private(set) var channels: [Channel]
    
    private let userDataRepository: UserDataRepository
    private let channelsRepository: ChannelsRepository

    @ObservationIgnored
    lazy var channelCreationViewModel: ChannelCreationViewModel = {
        let channelIdentifierChecker = ChannelIdentifierClient()
        let channelPhotoUploader = FilesUploadingService(userDataRepository: userDataRepository)
        
        return ChannelCreationViewModel(
            channelIdentifierChecker: channelIdentifierChecker,
            channelPhotoUploader: channelPhotoUploader, 
            channelsRepository: channelsRepository)
    }()
    
    // MARK: - Init
    init(userDataRepository: UserDataRepository, channelsRepository: ChannelsRepository) {
        self.channels = channelsRepository.channels
        self.userDataRepository = userDataRepository
        self.channelsRepository = channelsRepository
    }
}
