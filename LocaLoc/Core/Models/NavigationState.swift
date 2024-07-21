//
//  NavigationState.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/7/24.
//

import Foundation

enum NavigationState: Hashable {
    case createNewChannel
    case map(channel: Channel)
    case privateChannel(privateChannelModel: PrivateChannelModel)
}
