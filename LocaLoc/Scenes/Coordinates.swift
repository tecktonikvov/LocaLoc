//
//  Coordinates.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import CoreLocation

struct Coordinates {
    let longitude: Double
    let latitude: Double
    
    var as2DCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
