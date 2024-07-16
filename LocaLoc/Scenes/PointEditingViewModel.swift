//
//  PointEditingViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 15/7/24.
//

import Foundation
import K_Logger

@Observable final class PointEditingViewModel {
    private(set) var isApproveButtonLoading: Bool = false
    
    var channelPoint: ChannelPoint
    
    var selectedEmojiCode: String
    var selectedPointSingType: SelectedPointSingType
    
    @ObservationIgnored
    private let channelPointsRepository: ChannelPointsDataRepository
    
    // MARK: - Output
    var onSuccess: (() -> Void)?
    var onClose: (() -> Void)?

    // MARK: - Init
    init(channelPoint: ChannelPoint, channelPointsRepository: ChannelPointsDataRepository) {
        self.channelPoint = channelPoint
        self.channelPointsRepository = channelPointsRepository
        self.selectedPointSingType = channelPoint.emojiCode != nil ? .emoji : .default
        self.selectedEmojiCode = channelPoint.emojiCode ?? "😀"
    }
    
    // MARK: - Public
    func updatePoint() {
        channelPoint.emojiCode = selectedPointSingType == .emoji ? selectedEmojiCode : nil
        channelPoint.updatedAt = Date.timeZoneIndependentCurrentDate
        
        isApproveButtonLoading = true
        
        Task { @MainActor in
            do {
                try await channelPointsRepository.updateChannelPoint(channelPoint)
                Haptic.perform()
                onSuccess?()
            } catch {
                Log.error("Channel point update error: \(error)", module: "PointEditingViewModel")
            }
            
            isApproveButtonLoading = false
        }
    }
    
    func userTappedCloseButton() {
        onClose?()
    }
}
