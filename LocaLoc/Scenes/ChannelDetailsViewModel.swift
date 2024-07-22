//
//  ChannelDetailsViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 22/7/24.
//

import Foundation

struct ChannelDetailsModel: Equatable, Hashable {
    var channel: Channel
    var pointsNumber: Int
    var participantsNumber: Int
}


final class ChannelDetailsViewModel {
    private(set) var channelModel: ChannelDetailsModel
    
    // MARK: - Init
    init(channelDetailsModel: ChannelDetailsModel) {
        self.channelModel = channelDetailsModel
    }
    
    // MARK: - Public

}
