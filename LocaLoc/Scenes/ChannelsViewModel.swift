//
//  ChannelsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import Factory
import Foundation

@Observable final class ChannelsViewModel {
    private(set) var channels: [Channel] = []
    
    @ObservationIgnored
    @Injected(\.channelsRepository) private var channelsRepository
    
    let channelCreationViewModel = ChannelCreationViewModel()
    
    // MARK: - Init
    init() {
        self.channels = channelsRepository.channels
    }
}
