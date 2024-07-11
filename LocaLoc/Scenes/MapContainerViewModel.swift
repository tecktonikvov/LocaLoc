//
//  MapContainerViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import Foundation
import Factory

@Observable final class MapContainerViewModel {
    @ObservationIgnored
    private(set) var mapView: MapViewController
 
    @ObservationIgnored
    private(set) var selectedCoordinates: Coordinates?
    
    @ObservationIgnored
    private var mapController: MapController
    
    @ObservationIgnored
    private lazy var channelPointsRepository = Container.shared.channelPointsRepository(channel)

    @ObservationIgnored
    @Injected(\.userIdProvider) private var userIdProvider
    
    var dismiss = false
    var showAddPointView = false
    var showSynchronizationIndicator = false
    var pointCreationRequestInProgress = false
        
    private(set) var channel: Channel

    // MARK: - Init
    init(channel: Channel) {
        self.channel = channel
        
        let mapController = MapController()
        self.mapController = mapController
        
        let mapViewController = MapViewController(mapView: mapController.mapView)
        self.mapView = mapViewController
        
        try? channelPointsRepository.reload(with: channel)
        
        mapController.delegate = self
    }

    // MARK: - Public
    func backButtonTapped() {
        dismiss = true
    }
    
    func settingsButtonTapped() {
        
    }
    
    func recenterButtonTapped() {
        mapController.goToMyLocation()
    }
    
    func newPointApproved() {
        Task { @MainActor in
            guard let newSelectedMarker = mapController.newSelectedMarker else { return }
            
            pointCreationRequestInProgress = true

            do {
                try await Task.sleep(nanoseconds: 2.0.nanoseconds)
                
                let point = ChannelPoint(
                    id: UUID().uuidString,
                    channelId: channel.id,
                    latitude: newSelectedMarker.coordinates.latitude,
                    longitude: newSelectedMarker.coordinates.longitude,
                    address: "newSelectedMarker",
                    description: "Description",
                    creatorId: try userIdProvider.userId(),
                    createdAt: Date.timeZoneIndependentCurrentDate,
                    updatedAt: Date.timeZoneIndependentCurrentDate,
                    heading: 0.0,
                    lifeTime: nil,
                    emojiCode: nil,
                    isHidden: false
                )
                
                let pointWithId = try await channelPointsRepository.saveChannelPoint(point)
                mapController.setNewSelectedLocationSteady()
                
                self.channel.channelPoints.append(pointWithId)
            } catch {
                print("🔴", error)
            }
            
            showAddPointView = false
            pointCreationRequestInProgress = false
        }
    }
    
    func newPointCanceled() {
        mapController.removeNewSelectedLocation()
        showAddPointView = false
    }
    
    func addChannelPoints() {
        let points = channelPointsRepository.points
        mapController.addMarkers(forPoints: points)
    }
    
    // MARK: - Public
    func synchronizeChannelsPoints() {
        self.showSynchronizationIndicator = true
        
        Task { @MainActor in
            do {
                try await channelPointsRepository.synchronizeUserChannelPointsList()
                mapController.clearMarkers()
                addChannelPoints()
            } catch {
                print("🔴", error)
            }
            
            self.showSynchronizationIndicator = false
        }
    }
}

// MARK: - MapControllerDelegate
extension MapContainerViewModel: MapControllerDelegate {
    func didAddNewMarker(coordinates: Coordinates) {
        Haptic.perform()
        selectedCoordinates = coordinates
        showAddPointView = true
    }
}
