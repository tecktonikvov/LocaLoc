//
//  ChannelPointsDataRepository+ChannelPointsRepository.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 10/7/24.
//

import Factory
import SwiftUI
import K_Logger
import SwiftData
import LocaLocClient
import LocaLocLocalStore

@Observable class ChannelPointsDataRepository {
    var points: [ChannelPoint] = []
    
    private var channel: Channel
    private let localStorage: LocalStorage
    
    @ObservationIgnored
    @Injected(\.channelPointsClient) private var channelPointsClient
    
    // MARK: - Init
    init(localStorage: LocalStorage, channel: Channel) throws {
        self.localStorage = localStorage
        self.channel = channel

        try loadLocalStorePoints()
        
        //deleteAllLocalCachedChannels()
    }
    
    // MARK: - Private
//    private func deleteAllLocalCachedChannels() {
//        try? localStorage.deleteAllModels(withTypes: ChannelPersistencyModel.self)
//        try? reloadLocalStoreChannels()
//    }
    
    private func loadLocalStorePoints() throws {
        let channelId = channel.id
        let predicate = #Predicate<ChannelPointPersistencyModel> { $0.channelId == channelId }
        let descriptor = FetchDescriptor<ChannelPointPersistencyModel>(predicate: predicate)
        
        let pointsLocalModels = try localStorage.fetchModelsWith(
            model: ChannelPointPersistencyModel.self,
            descriptor: descriptor
        )
        
        let points = pointsLocalModels.compactMap { ChannelPoint(channelPointPersistencyModel: $0) }
        self.points = points
        Log.info("Loaded \(points.count) points from local storage", module: "ChannelPointsDataRepository")
    }
    
    private func reloadLocalStorePoints() throws {
        try loadLocalStorePoints()
    }
    
    private func points(ids: [String]) async throws -> [ChannelPointPersistencyModel] {
        guard !ids.isEmpty else { return [] }
        
        let points = try await withThrowingTaskGroup(of: ChannelPointPersistencyModel?.self,
                                                     returning: [ChannelPointPersistencyModel?].self) { taskGroup in
            for id in ids {
                taskGroup.addTask { [weak self] in
                    guard let self,
                          let clientModel = try await channelPointsClient.point(withId: id) else {
                        return nil
                    }
                                                
                    return ChannelPointPersistencyModel(channelClientModel: clientModel, id: id)
                }
            }

            var points = [ChannelPointPersistencyModel?]()

            while let fetchedPoint = try await taskGroup.next() {
                points.append(fetchedPoint)
            }
            
            return points
        }
        
        return points.compactMap { $0 }
    }
}

extension ChannelPointsDataRepository: ChannelPointsRepository {
    func synchronizeUserChannelPointsList() async throws {
        Log.info("Channels points list synchronization started", module: "ChannelPointsDataRepository")
        
        let pointsIds = try await channelPointsClient.pointsIds(forChannelWithId: channel.id)
        
        // Delete cached points
        let channelId = channel.id
        let predicate = #Predicate<ChannelPointPersistencyModel> { $0.channelId == channelId }
        let descriptor = FetchDescriptor<ChannelPointPersistencyModel>(predicate: predicate)
        try localStorage.deleteAll(model: ChannelPointPersistencyModel.self, descriptor: descriptor)
        Log.info("Cached channel points deleted", module: "ChannelPointsDataRepository")
        
        // Add actual models
        let channelPointsLocalStoreModels = try await points(ids: pointsIds)
        Log.info("Initialized new channel points models", module: "ChannelPointsDataRepository")

        for channelPointLocalStoreModel in channelPointsLocalStoreModels {
            localStorage.addModel(model: channelPointLocalStoreModel)
        }
        
        // Update UI
        try reloadLocalStorePoints()
        
        Log.info("Channels points list synchronization finished. Fetched \(channelPointsLocalStoreModels.count) points", module: "ChannelPointsDataRepository")
    }
    
    func saveChannelPoint(_ point: ChannelPoint) async throws -> ChannelPoint {
        let channelPointClientModel = ChannelPointClientModel(channelPointModel: point)
        let pointId = try await channelPointsClient.savePoint(pointClientModel: channelPointClientModel)
        
        let pointModelWithId = ChannelPoint(channelPointClientModel: channelPointClientModel, id: pointId)
        let pointLocalStoreModel = ChannelPointPersistencyModel(channelPointModel: pointModelWithId)
        localStorage.addModel(model: pointLocalStoreModel)
        
        points.append(pointModelWithId)
        
        return pointModelWithId
    }
    
    func updateChannelPoint(_ point: ChannelPoint) async throws {
        // Update client data
        let channelPointClientModel = ChannelPointClientModel(channelPointModel: point)
        try await channelPointsClient.updatePoint(withId: point.id, pointClientModel: channelPointClientModel)
        
        try  await synchronizeUserChannelPointsList()
    }
    
    func delete(point: ChannelPoint) async throws {
        try await channelPointsClient.delete(pointWithId: point.id)
        try await synchronizeUserChannelPointsList()
    }
}
