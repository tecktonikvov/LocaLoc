//
//  ChannelsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/5/24.
//

import Factory
import Foundation

@Observable final class ChannelsViewModel {
    @ObservationIgnored
    @Injected(\.channelsRepository) var channelsRepository
    
    let channelCreationViewModel = ChannelCreationViewModel()
    
    var isDataSynchronizationRunning = false
    
    // MARK: - Public
    func synchronizeUserChannelsList() {
        isDataSynchronizationRunning = true
        
        Task { @MainActor in
            do {
                try await channelsRepository.synchronizeUserChannelsList()
            } catch {
                print("🔴", error)
            }
            
            isDataSynchronizationRunning = false
        }
    }
}
