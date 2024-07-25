//
//  ChannelDetailsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import Foundation
import Factory
import SwiftUI

struct ChannelDetailsModel: Equatable, Hashable {
    let channel: Channel
    let pointsNumber: Int
    let participantsNumber: Int
    let isChannelOwner: Bool
}

enum ShareItemType {
    case free(shareItem: ShareItem)
    case invitation(shareItem: ShareItem)
}

final class ChannelDetailsViewModel {
    private(set) var channelModel: ChannelDetailsModel
    
    @ObservationIgnored
    @Injected(\.userIdProvider) private var userIdProvider
    
    private(set) var shareItemType: ShareItemType?
    
    // MARK: - Init
    init(channelDetailsModel: ChannelDetailsModel) {
        self.channelModel = channelDetailsModel
        setShareItem()
    }
    
    // MARK: - Private
    private func setShareItem() {
        let invitationMode = channelModel.channel.channelSettings.invitationMode
        guard let url = URL(string: "localocapp://channel?identifier=QEqgSzGPu5Kk2kcQcRBA") else {
            return
        }
        
        switch invitationMode {
        case .open:
            let item = ShareItem(
                image: Image("share_sheet_icon"),
                title: "Share channel link",
                link: url)
            
            shareItemType = .free(shareItem: item)
        case .byInvitation:
            if channelModel.isChannelOwner {
                let item = ShareItem(
                    image: Image("share_sheet_icon"),
                    title: "Share invitation link",
                    link: url)
                
                shareItemType = .invitation(shareItem: item)
            } else {
                let item = ShareItem(
                    image: Image("share_sheet_icon"),
                    title: "Share channel link",
                    link: url)
                
                shareItemType = .free(shareItem: item)
            }
        }
    }
    
    // MARK: - Public
    func userTappedEditButton() {
        
    }
    
    func userTappedLeaveButton() {
        
    }
}
