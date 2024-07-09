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
        
    var showLoadingIndicator = false

    // MARK: - Public
    func synchronizeUserChannelsList(showLoadingIndicator: Bool) {
        if showLoadingIndicator {
            self.showLoadingIndicator = true
        }
        
        Task { @MainActor in
            do {
                try await channelsRepository.synchronizeUserChannelsList()
            } catch {
                print("🔴", error)
            }
            
            if showLoadingIndicator {
                self.showLoadingIndicator = false
            }
        }
    }
}
