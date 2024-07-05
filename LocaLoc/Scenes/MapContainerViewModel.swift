//
//  MapContainerViewModel.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import Foundation

@Observable final class MapContainerViewModel {
    @ObservationIgnored
    private(set) var mapView: MapViewController
    @ObservationIgnored
    private var mapController: MapController
    
    private(set) var channel: Channel

    var dismiss = false
    var showAddPointView = false
    
    var selectedCoordinates: Coordinates?

    // MARK: - Init
    init(channel: Channel) {
        self.channel = channel
        
        let mapController = MapController()
        self.mapController = mapController
        
        let mapViewController = MapViewController(mapView: mapController.mapView)
        self.mapView = mapViewController
        
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
        mapController.setNewSelectedLocationSteady()
    }
    
    func newPointCanceled() {
        mapController.removeNewSelectedLocation()
    }
}

// MARK: - MapControllerDelegate
extension MapContainerViewModel: MapControllerDelegate {
    func didAddNewMarker(coordinates: Coordinates) {
        selectedCoordinates = coordinates
        showAddPointView = true
    }
}
