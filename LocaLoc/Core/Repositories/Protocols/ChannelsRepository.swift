//
//  ChannelsRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 30/6/24.
//

import Foundation

protocol ChannelsRepository {
    var channels: [Channel] { get }
    
    /// Creates channel if id is empty and updates if not. Returns updated Channel model with id and saved in to local and remote storage
    @discardableResult func saveChannel(_ channel: Channel) async throws -> Channel
    func fetchChannel(withId: String) async throws -> Channel?
    func synchronizeUserChannelsList() async throws
    func cleanChannelsList()
    func subscribersNumber(channelId: String) -> Int?
    func saveSubscribersNumber(forChannelWithId channelId: String, number: Int)
}
