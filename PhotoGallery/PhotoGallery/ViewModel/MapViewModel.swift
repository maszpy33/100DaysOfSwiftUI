//
//  MapViewModel.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 04.08.22.
//

import Foundation
import CoreLocation


class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        print("location request")
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        print("Location requeswt confirmed")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
