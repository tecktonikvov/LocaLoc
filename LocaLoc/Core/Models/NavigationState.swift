//
//  NavigationState.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/7/24.
//

import Foundation

enum NavigationState: Hashable {
    case createNewChannel
    case map(channel: Channel, relationType: UserChannelSubscriptionRelationType)
    case privateChannel(privateChannelModel: PrivateChannelModel)
    case channelDetails(channelDetailsModel: ChannelDetailsModel)
    case profileEditing
}
