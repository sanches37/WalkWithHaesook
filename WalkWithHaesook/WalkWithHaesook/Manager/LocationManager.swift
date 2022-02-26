//
//  LocationManager.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    private let locationManger = CLLocationManager()
    var locationCompletion: ((CLLocation) -> Void)?
    
    func getUserLocation(completion: @escaping (CLLocation) -> Void) {
        self.locationCompletion = completion
    }
    
    override init() {
        super.init()
        locationManger.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationCompletion?(location)
    }
    
    @available(iOS, deprecated: 14.0)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        decidedAuthorization(status: status)
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        decidedAuthorization(status: manager.authorizationStatus)
    }
    
    private func decidedAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
        case .denied:
            debugPrint("denied")
        case .authorizedWhenInUse:
            locationManger.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}
