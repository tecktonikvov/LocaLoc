//
//  Marker.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import GoogleMaps

struct MarkerConfig {
    let size: CGSize
    
    static let defaultConfig = MarkerConfig(size: CGSize(width: 22, height: 32))
}

final class Marker: Equatable {
    enum MarkerType {
        case new(hidden: Bool)
        case viewed(hidden: Bool)
        case notApproved
    }
    
    static func == (lhs: Marker, rhs: Marker) -> Bool {
        lhs.id == rhs.id
        && lhs.coordinates == rhs.coordinates
    }
    
    let id: String
    let config: MarkerConfig

    var type: MarkerType {
        didSet {
            setImage(name: type.imageName, marker: gMSMarker)
        }
    }

    let gMSMarker: GMSMarker
    
    var coordinates: Coordinates {
        didSet {
            gMSMarker.position = coordinates.as2DCoordinates
        }
    }
    
    // MARK: - Init
    init(id: String, coordinates: Coordinates, type: MarkerType, config: MarkerConfig = .defaultConfig) {
        self.id = id
        self.type = type
        self.config = config
        self.coordinates = coordinates

        let marker = GMSMarker(position: coordinates.as2DCoordinates)
        marker.appearAnimation = .pop
        
        self.gMSMarker = marker
        
        setImage(name: type.imageName, marker: gMSMarker)
    }
    
    // MARK: - Private
    private func setImage(name: String, marker: GMSMarker) {
        marker.icon = UIImage(named: name)
        marker.setIconSize(scaledToSize: CGSize(width: config.size.width, height: config.size.height))
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

fileprivate extension Marker.MarkerType {
    var imageName: String {
        switch self {
        case .new(let hidden):
            if hidden {
                return "marker_new_hidden"
            } else {
                return "marker_new"
            }
        case .viewed(let hidden):
            if hidden {
                return "marker_viewed_hidden"
            } else {
                return "marker_viewed"
            }
        case .notApproved:
            return "marker_not_approved"
        }
    }
}
