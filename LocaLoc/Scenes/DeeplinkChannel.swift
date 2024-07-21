//
//  DeeplinkChannel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 18/7/24.
//

import Foundation

enum DeeplinkChannel: Equatable {
    static func == (lhs: DeeplinkChannel, rhs: DeeplinkChannel) -> Bool {
        switch lhs {
        case .openChannel(let lhsChannel):
            switch rhs {
            case .openChannel(let rhsChannel):
                return lhsChannel == rhsChannel
            case .privateChannel(let rhsChannelChannelModel):
                return lhsChannel == rhsChannelChannelModel.channel
            }
        case .privateChannel(let lhsChannelChannelModel):
            switch rhs {
            case .openChannel(let rhsChannel):
                return lhsChannelChannelModel.channel == rhsChannel
            case .privateChannel(let rhsChannelChannelModel):
                return rhsChannelChannelModel.channel == rhsChannelChannelModel.channel
            }
        }
    }
    
    case openChannel(Channel)
    case privateChannel(PrivateChannelModel)
    
    var identifier: String {
        switch self {
        case .openChannel(let channel):
            return channel.identifier
        case .privateChannel(let privateChannelModel):
            return privateChannelModel.channel.identifier
        }
    }
}
