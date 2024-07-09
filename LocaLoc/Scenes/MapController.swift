//
//  MapController.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import GoogleMaps

protocol MapControllerDelegate: AnyObject {
    func didAddNewMarker(coordinates: Coordinates)
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
    
    private var newSelectedMarker: Marker?
    
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
    
    private func centerCamera(at location: CLLocation) {
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 15.0
        )
        
        mapView.animate(to: camera)
    }
    
    // MARK: - Public
    func goToMyLocation() {
        guard let lastUserLocation else { return }
        centerCamera(at: lastUserLocation)
    }
    
    func removeNewSelectedLocation() {
        guard let newSelectedMarker else { return }
        newSelectedMarker.removeMarkerFromMap()
        self.newSelectedMarker = nil
    }
    
    func setNewSelectedLocationSteady() {
        guard let newSelectedMarker else { return }
        newSelectedMarker.setSteadyAppearance()
        markers.append(newSelectedMarker)
        self.newSelectedMarker = nil
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
            coordinates: coordinates
        )
        
        newSelectedMarker.addMarker(on: mapView)
        self.newSelectedMarker = newSelectedMarker
        
        delegate?.didAddNewMarker(coordinates: newSelectedMarker.coordinates)
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
