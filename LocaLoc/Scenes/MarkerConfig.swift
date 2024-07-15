//
//  MarkerConfig.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 15/7/24.
//

import GoogleMaps

struct MarkerConfig {
    let markerSize: CGSize
    let newMarkerIndicatorSize: CGSize
    let appearAnimation: GMSMarkerAnimation
    
    static let defaultConfig = MarkerConfig(
        markerSize: CGSize(width: 22, height: 32),
        newMarkerIndicatorSize: CGSize(width: 8, height: 8),
        appearAnimation: .pop)
}
