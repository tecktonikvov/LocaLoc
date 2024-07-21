//
//  PrivateChannelViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 18/7/24.
//

import Foundation

@Observable final class PrivateChannelViewModel {
    init(channelModel: PrivateChannelModel) {
        self.channelModel = channelModel
    }
    
    var channelModel: PrivateChannelModel
}
