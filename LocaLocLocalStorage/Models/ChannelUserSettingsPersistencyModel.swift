//
//  ChannelUserSettingsPersistencyModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 9/7/24.
//

import SwiftData

@Model
public final class ChannelUserSettingsPersistencyModel {
    public var isMuted: Bool
    let channel: ChannelPersistencyModel
    
    public init(isMuted: Bool, channel: ChannelPersistencyModel) {
        self.isMuted = isMuted
        self.channel = channel
    }
}
