//
//  LocationService.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 6.04.2025.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate{
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    func requestLocation() {
        
    }
}
