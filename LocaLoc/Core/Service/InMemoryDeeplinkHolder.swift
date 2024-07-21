//
//  InMemoryDeeplinkHolder.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 19/7/24.
//

import Foundation

struct InMemoryDeeplinkHolder {
    private init() {}
    
    static var channelDeepLink: ChannelDeeplinkModel? {
        didSet {
            guard let channelDeepLink else { return }
            onChannelDeepLinkSet?(channelDeepLink)
        }
    }
    
    static var onChannelDeepLinkSet: ((ChannelDeeplinkModel) -> Void)?
}
