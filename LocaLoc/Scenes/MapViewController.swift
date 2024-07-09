//
//  MapViewController.swift
//  LocaLoc
//
//  Created by Volodymyr Kotsiubenko on 4/7/24.
//

import UIKit
import SwiftUI
import GoogleMaps

protocol MapView: UIViewController {}

final class MapViewController: UIViewController, MapView {
    private let mapView: GMSMapView
    private var mapOverlayView: UIView?
    
    init(mapView: GMSMapView) {
        self.mapView = mapView
        super.init(nibName: nil, bundle: nil)
        mapOverlayView = mapView.subviews[safe: 1]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = mapView
        
        // Hide blinking
        mapOverlayView?.backgroundColor = UIColor(Color.background)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.3) {
                self.mapOverlayView?.backgroundColor = .clear
            }
        }
    }
}
