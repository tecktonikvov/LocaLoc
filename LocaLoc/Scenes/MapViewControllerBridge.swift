//
//  MapViewControllerBridge.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 5/7/24.
//

import SwiftUI

struct MapViewControllerBridge: UIViewControllerRepresentable {
    private let mapViewController: MapViewController
    
    init(mapViewController: MapViewController) {
        self.mapViewController = mapViewController
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        mapViewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
    }
}
