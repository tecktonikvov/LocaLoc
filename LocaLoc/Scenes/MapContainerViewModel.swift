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
    
    // New point properties
    var showPoint: Bool = false
    var description: String = ""
    var addressString: String = ""
    var lifetime: Int? // Not implemented
    var emojiCode: String? // Not implemented
    var heading: Double? // Not implemented

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
    
    // MARK: - Private
    private func clearCurrentPointData() {
        description = ""
        addressString = ""
        lifetime = nil
        emojiCode = nil
        heading = nil
        showPoint = false
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
                let point = ChannelPoint(
                    id: UUID().uuidString,
                    channelId: channel.id,
                    latitude: newSelectedMarker.coordinates.latitude,
                    longitude: newSelectedMarker.coordinates.longitude,
                    address: addressString,
                    description: description,
                    creatorId: try userIdProvider.userId(),
                    createdAt: Date.timeZoneIndependentCurrentDate,
                    updatedAt: Date.timeZoneIndependentCurrentDate,
                    heading: heading,
                    lifeTime: lifetime,
                    emojiCode: emojiCode,
                    isHidden: !showPoint
                )
                
                let pointWithId = try await channelPointsRepository.saveChannelPoint(point)
                mapController.setNewSelectedPointSteady(hidden: !showPoint)
                
                self.channel.channelPoints.append(pointWithId)
                Haptic.perform(.success)
                
                clearCurrentPointData()
            } catch {
                print("🔴", error)
                Haptic.perform(.error)
            }
            
            showAddPointView = false
            pointCreationRequestInProgress = false
        }
    }
    
    func newPointCanceled() {
        mapController.removeNewSelectedPoint()
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
