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
        marker.setIconSize(scaledToSize: CGSize(width: 22, height: 32))
        
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

fileprivate extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
