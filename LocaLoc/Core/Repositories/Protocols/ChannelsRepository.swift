//
//  ChannelsRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import Foundation

protocol ChannelsRepository {
    var channels: [Channel] { get }
    func saveChannel(_ channel: Channel) async throws
}
