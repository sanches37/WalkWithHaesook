//
//  MapViewModel.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import SwiftUI
import NMapsMap
import Combine

class MapViewModel: ObservableObject {
    private let locationManager = LocationManager()
    private let latLngDummy = LatLngDummy()
    private var subscriptions = Set<AnyCancellable>()
    let mapView = NMFMapView()
    var markerArray: [NMFMarker] = []
    @Published var region: NMGLatLng?
    @Published var deniedMassage: String?
    
    init() {
        getUserLocation()
    }
    
    private func getUserLocation() {
        locationManager.locationSubject.sink { result in
            if case .failure(let error) = result {
                self.deniedMassage = error.localizedDescription
            }
        } receiveValue: { location in
            self.region = NMGLatLng(lat: location.coordinate.latitude,
                                     lng: location.coordinate.longitude)
        }
        .store(in: &subscriptions)
    }
    
    func focusLocation() {
        guard let region = region else { return }
        mapView.positionMode = .direction
        let cameraUpdate = NMFCameraUpdate(scrollTo: region)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        mapView.moveCamera(cameraUpdate)
    }
    
    private func convertMarkers(mapView: NMFMapView) {
        let markersPosition = markerArray.map { $0.position }
        latLngDummy.latLng.forEach { latLng in
            let marker = NMFMarker(position: latLng)
            if !markersPosition.contains(latLng) {
                markerArray.append(marker)
            }
        }
    }
    
    func updateMarkers(mapView: NMFMapView) {
        convertMarkers(mapView: mapView)
        markerArray.forEach { marker in
            if mapView.contentBounds.hasPoint(marker.position) {
                marker.mapView = mapView
            } else {
                marker.mapView = nil
            }
        }
    }
}
