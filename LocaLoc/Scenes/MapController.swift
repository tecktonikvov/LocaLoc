//
//  MapController.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import SwiftUI
import GoogleMaps

protocol MapControllerDelegate: AnyObject {
    func didAddNewMarker(coordinates: Coordinates)
    func didTapOnMarker(withId pointId: String, markerViewFrame: CGRect)
    func didChangeCameraPosition()
}

final class MapController: NSObject {
    lazy var mapView: GMSMapView = {
        let options = GMSMapViewOptions()
        let view = GMSMapView(options: options)
        view.isMyLocationEnabled = true
        view.settings.tiltGestures = false
        return view
    }()
    
    private let locationManager: CLLocationManager
    
    private var isInitialLocationSet = false
    private var lastUserLocation: CLLocation?
    
    private var markers = [Marker]()
    
    private(set) var newSelectedMarker: Marker?
    
    weak var delegate: MapControllerDelegate?
    
    // MARK: - Init
    override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        mapView.delegate = self
        locationManager.delegate = self
        
        setupMapStyle()
        startUpdatingLocation()
    }
    
    // MARK: - Private
    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func setupMapStyle() {
        guard let styleURL = Bundle.main.url(forResource: "googleMapsStyleDark", withExtension: "json") else {
            return
        }
        
        mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
    }
    
    private func centerCamera(at location: CLLocation, zoom: Float = 15) {
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: zoom
        )
        
        mapView.animate(to: camera)
    }
    
    private func markerModel(forGMSMarker GMSMarker: GMSMarker) -> Marker? {
        markers.first(where: { $0.gMSMarker == GMSMarker })
    }
    
    private func markersToUpdate(points: [ChannelPoint]) -> [Marker] {
        var result = [Marker]()

        let newMarkers = points.map {
            Marker(
                id: $0.id,
                coordinates: Coordinates(longitude: $0.longitude,
                                         latitude: $0.latitude),
                type: .viewed,
                emojiCode: $0.emojiCode,
                isHidden: $0.isHidden
            )
        }
        
        for marker in newMarkers where !markers.contains(marker) {
            result.append(marker)
        }
        
        return result
    }
    
    // MARK: - Public
    func goToMyLocation() {
        guard let lastUserLocation else { return }
        centerCamera(at: lastUserLocation)
    }
    
    func removeNewSelectedPoint() {
        guard let newSelectedMarker else { return }
        newSelectedMarker.removeMarkerFromMap()
        self.newSelectedMarker = nil
    }
    
    func replaceNewSelectedPoint(by point: ChannelPoint) {
        removeNewSelectedPoint()
        
        let marker = Marker(
            id: point.id,
            coordinates: Coordinates(longitude: point.longitude,
                                     latitude: point.latitude),
            type: .new,
            emojiCode: point.emojiCode,
            isHidden: point.isHidden
        )
        
        marker.addMarker(on: mapView)
        
        markers.append(marker)
    }
    
    func addMarkers(forPoints points: [ChannelPoint]) {
        updateMarkersIfNeeded(points: points)
    }
    
    func clearMarkers() {
        mapView.clear()
        markers.removeAll()
    }
    
    func updateMarkersIfNeeded(points: [ChannelPoint]) {
        let markersToUpdate = markersToUpdate(points: points)
        
        for marker in markersToUpdate {
            // Remove marker from map
            let existingMarker = markers.first(where: { $0.id == marker.id })
            existingMarker?.removeMarkerFromMap()
            
            // Remove marker from markers list
            markers.removeAll(where: { $0.id == marker.id })
            
            // Add updated or new marker to markers list
            markers.append(marker)
            
            // Add updated or new marker image to map
            marker.addMarker(on: self.mapView)
        }
    }
    
    func focusCamera(on point: ChannelPoint) {
        let coordinates = Coordinates(
            longitude: point.longitude,
            latitude: point.latitude - 0.005 // Add small bottom inset
        )
        
        mapView.animate(toLocation: coordinates.as2DCoordinates)
    }
}

// MARK: - GMSMapViewDelegate
extension MapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        guard newSelectedMarker == nil else { return }
        
        let coordinates = Coordinates(
            longitude: coordinate.longitude,
            latitude: coordinate.latitude
        )
        
        let newSelectedMarker = Marker(
            id: UUID().uuidString,
            coordinates: coordinates,
            type: .notApproved, 
            emojiCode: nil, 
            isHidden: false
        )
        
        newSelectedMarker.addMarker(on: mapView)
        self.newSelectedMarker = newSelectedMarker
        
        delegate?.didAddNewMarker(coordinates: newSelectedMarker.coordinates)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let markerModel = markerModel(forGMSMarker: marker) else {
            return true
        }
        
        mapView.selectedMarker = marker

        let point = mapView.projection.point(for: marker.position)
        
        let markerViewFrame = CGRect(
            x: point.x - markerModel.config.markerSize.width * 0.5, // For some reason it returns wrong value
            y: point.y,
            width: markerModel.config.markerSize.width,
            height: markerModel.config.markerSize.height
        )
        
        delegate?.didTapOnMarker(withId: markerModel.id, markerViewFrame: markerViewFrame)
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        delegate?.didChangeCameraPosition()
    }
}

// MARK: - CLLocationManagerDelegate
extension MapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if !isInitialLocationSet {
            isInitialLocationSet = true
            centerCamera(at: location)
        }
        
        self.lastUserLocation = location
    }
}
