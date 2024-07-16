//
//  Marker.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import GoogleMaps
import SwiftUI

final class Marker: Equatable {
    enum MarkerType {
        case new
        case viewed
        case notApproved
    }
    
    static func == (lhs: Marker, rhs: Marker) -> Bool {
        lhs.id == rhs.id
        && lhs.coordinates == rhs.coordinates
        && lhs.emojiCode == rhs.emojiCode
        && lhs.type == rhs.type
        && lhs.isHidden == rhs.isHidden
    }
    
    let id: String
    let config: MarkerConfig
    let gMSMarker: GMSMarker

    var type: MarkerType {
        didSet {
            updateMakerAppearance()
        }
    }
    
    var coordinates: Coordinates {
        didSet {
            gMSMarker.position = coordinates.as2DCoordinates
        }
    }
    
    var emojiCode: String? {
        didSet {
            updateMakerAppearance()
        }
    }
    
    var isHidden: Bool {
        didSet {
            updateMakerAppearance()
        }
    }
    
    // MARK: - Init
    init(
        id: String,
        coordinates: Coordinates,
        type: MarkerType,
        emojiCode: String?,
        isHidden: Bool,
        config: MarkerConfig = .defaultConfig
    ) {
        self.id = id
        self.type = type
        self.config = config
        self.isHidden = isHidden
        self.emojiCode = emojiCode
        self.coordinates = coordinates
        self.gMSMarker = GMSMarker(position: coordinates.as2DCoordinates)
        
        gMSMarker.appearAnimation = config.appearAnimation
                
        updateMakerAppearance()
    }
    
    // MARK: - Public
    func addMarker(on mapView: GMSMapView) {
        gMSMarker.map = mapView
    }
    
    func removeMarkerFromMap() {
        gMSMarker.map = nil
    }
}

extension Marker {
    private func updateMakerAppearance() {
        Task { @MainActor in
            let image = markerImage()
            gMSMarker.icon = image
        }
    }
    
    @MainActor
    private func markerImage() -> UIImage? {
        if let emojiCode {
            return makeEmojiImage(emojiCode: emojiCode)
        } else {
            return makeDefaultImage()
        }
    }
    
    @MainActor
    private func makeEmojiImage(emojiCode: String) -> UIImage? {
        var view = PointEmojiSignView(emojiCode: .constant(emojiCode))
        view.alpha = isHidden ? 0.5 : 1
        view.size = config.markerSize
        view.isNew = type == .new
        
        guard let image = view.snapshot() else {
            return nil
        }
       
        return image
    }
    
    private func makeDefaultImage() -> UIImage? {
        let markerImage = UIImage(named: type.imageName)
        let newMarkerIndicatorImage = type == .new ? UIImage(named: "red_dot") : nil
        let alpha = isHidden ? 0.5 : 1

        // Begin context
        UIGraphicsBeginImageContextWithOptions(config.markerSize, false, 0.0)
        
        // Add markerImage
        let markerImageRect = CGRect(
            x: 0, y: 0,
            width: config.markerSize.width,
            height: config.markerSize.height
        )
        markerImage?.draw(in: markerImageRect, blendMode: .normal, alpha: alpha)
        
        // Add new marker indicator
        if let newMarkerIndicatorImage {
            let size = config.newMarkerIndicatorSize
            let x = config.markerSize.width - size.width * 0.5
            let y = 0.0
            let newMarkerIndicatorRect = CGRect(x: x, y: y, width: size.width, height: size.height)
            
            newMarkerIndicatorImage.draw(in: newMarkerIndicatorRect, blendMode: .normal, alpha: alpha)
        }
        
        // Get image
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        // End context
        UIGraphicsEndImageContext()
                
        return newImage
    }
}

fileprivate extension Marker.MarkerType {
    var imageName: String {
        switch self {
        case .viewed, .new:
            return "marker_default"
        case .notApproved:
            return "marker_not_approved"
        }
    }
}
