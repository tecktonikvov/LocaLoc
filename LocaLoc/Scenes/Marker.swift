//
//  Marker.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import GoogleMaps

final class Marker {
    let id: String

    private let gMSMarker: GMSMarker
    
    var coordinates: Coordinates {
        didSet {
            gMSMarker.position = coordinates.as2DCoordinates
        }
    }
    
    // MARK: - Init
    init(id: String, coordinates: Coordinates) {
        self.id = id
        self.coordinates = coordinates
        
        let marker = GMSMarker(position: coordinates.as2DCoordinates)
        marker.icon = UIImage(named: "marker_brand")
        
        self.gMSMarker = marker
    }
    
    // MARK: - Public
    func addMarker(on mapView: GMSMapView) {
        gMSMarker.map = mapView
    }
    
    func removeMarkerFromMap() {
        gMSMarker.map = nil
    }
}
