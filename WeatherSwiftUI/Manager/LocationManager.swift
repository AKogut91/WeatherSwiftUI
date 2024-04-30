//
//  LocationManager.swift
//  WeatherSwiftUI
//
//  Created by Alex Kogut on 4/29/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager =  CLLocationManager()
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           switch manager.authorizationStatus {
           case .authorizedWhenInUse:  // Location services are available.
               // Insert code here of what should happen when Location services are authorized
               authorizationStatus = .authorizedWhenInUse
               locationManager.requestLocation()
               break
               
           case .restricted:  // Location services currently unavailable.
               // Insert code here of what should happen when Location services are NOT authorized
               authorizationStatus = .restricted
               break
               
           case .denied:  // Location services currently unavailable.
               // Insert code here of what should happen when Location services are NOT authorized
               authorizationStatus = .denied
               break
               
           case .notDetermined:        // Authorization not determined yet.
               authorizationStatus = .notDetermined
               manager.requestWhenInUseAuthorization()
               break
               
           default:
               break
           }
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
