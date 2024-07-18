//
//  ChannelPointsRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 10/7/24.
//

import Foundation

protocol ChannelPointsRepository {
    var points: [ChannelPoint] { get }
    
    /// Creates and saves point in remote and local storage. Returns updated point model with external id.
    @discardableResult func saveChannelPoint(_ point: ChannelPoint) async throws -> ChannelPoint
    func reload(with channel: Channel) throws
    func synchronizeUserChannelPointsList() async throws
    func updateChannelPoint(_ point: ChannelPoint) async throws
    func delete(point: ChannelPoint) async throws
}
