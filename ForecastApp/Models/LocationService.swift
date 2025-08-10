//
//  LocationService.swift
//  ForecastApp
//
//  Created by Seymen Özdeş on 6.04.2025.
//

import CoreLocation
import Foundation

protocol LocationServiceDelegate: AnyObject {
    func locationService(_: LocationService, didUpdateLocation Location: CLLocation)
    func locationService(_: LocationService, didFailWithError: Error)
}

class LocationService: NSObject {
    let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate? // üst katmana bildirim yapacak nesne

    override init() {
        super.init()
        prepareLocationManager()
    }
}

extension LocationService {
    private func prepareLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 5000 // 1km'lik hareket etmediğin sürece konum güncellemesi yapma
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func stopRequestLocation() {
        locationManager.stopUpdatingLocation()
    }

    func requestLocationPermission() {
        let authorizationStatus: CLAuthorizationStatus

        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse: // İzin var, konumu alabiliriz
            requestLocation()

        case .denied, .restricted: // Kullanıcı izin vermemiş veya kısıtlamış
            let error = NSError(domain: "LocationServiceErrorDomain",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Konum izni verilmedi. Lütfen ayarlardan izin verin."])
            delegate?.locationService(self, didFailWithError: error)

        @unknown default:
            break
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()

        case .denied, .restricted:
            let error = NSError(domain: "LocationServiceErrorDomain",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Konum izni verilmedi. Lütfen ayarlardan izin verin."])
            delegate?.locationService(self, didFailWithError: error)

        @unknown default:
            break
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: any Error) {
        delegate?.locationService(self, didFailWithError: error)
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.locationService(self, didUpdateLocation: location)
    }
}
