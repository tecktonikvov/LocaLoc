//
//  ChannelSettingsPersistencyModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 9/7/24.
//

import SwiftData

@Model
public final class ChannelSettingsPersistencyModel {
    public var invitationMode: String
    let channel: ChannelPersistencyModel
    
    public init(invitationMode: String, channel: ChannelPersistencyModel) {
        self.channel = channel
        self.invitationMode = invitationMode
    }
}
