//
//  LocationManager.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import CoreLocation
import Combine

class LocationManager: NSObject {
  private let locationManger = CLLocationManager()
  var locationSubject = PassthroughSubject<CLLocation?, Never>()
  
  override init() {
    super.init()
    locationManger.delegate = self
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    locationSubject.send(location)
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    decidedAuthorization(status: manager.authorizationStatus)
  }
  
  private func decidedAuthorization(status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      locationManger.requestWhenInUseAuthorization()
    case .denied:
      locationSubject.send(nil)
    case .authorizedAlways, .authorizedWhenInUse:
      locationManger.startUpdatingLocation()
    default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    debugPrint(error.localizedDescription)
  }
}
