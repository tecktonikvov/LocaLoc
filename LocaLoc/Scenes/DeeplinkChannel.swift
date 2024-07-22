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
        case .accessAllowed(let lhsChannel, _):
            switch rhs {
            case .accessAllowed(let rhsChannel, _):
                return lhsChannel == rhsChannel
            case .accessDenied(let rhsChannelChannelModel):
                return lhsChannel == rhsChannelChannelModel.channel
            }
        case .accessDenied(let lhsChannelChannelModel):
            switch rhs {
            case .accessAllowed(let rhsChannel, _):
                return lhsChannelChannelModel.channel == rhsChannel
            case .accessDenied(let rhsChannelChannelModel):
                return rhsChannelChannelModel.channel == rhsChannelChannelModel.channel
            }
        }
    }
    
    case accessAllowed(Channel, relationType: UserChannelSubscriptionRelationType)
    case accessDenied(PrivateChannelModel)
    
    var identifier: String {
        switch self {
        case .accessAllowed(let channel, _):
            return channel.identifier
        case .accessDenied(let privateChannelModel):
            return privateChannelModel.channel.identifier
        }
    }
}
