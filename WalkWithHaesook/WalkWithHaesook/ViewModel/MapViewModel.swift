//
//  MapViewModel.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import NMapsMap
import Combine

class MapViewModel: ObservableObject {
    private let walkRepository = WalkRepository()
    private let locationManager = LocationManager()
    private var subscriptions = Set<AnyCancellable>()
    let mapView = NMFMapView()
    private var markerArray: [NMFMarker] = []
    @Published var region: NMGLatLng?
    @Published var permissionDenied = false
    @Published var screenWalkList: [WalkList] = []
    
    init() {
        getUserLocation()
    }
    
    private func getUserLocation() {
        locationManager.locationSubject.sink { location in
            if let location = location {
                self.region = NMGLatLng(lat: location.coordinate.latitude,
                                        lng: location.coordinate.longitude)
            } else {
                self.permissionDenied = true
            }
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
   
    private func convertMarkers() {
        let markersPosition = markerArray.map { $0.position }
        walkRepository.walkList.forEach {
            let latLng = NMGLatLng(lat: $0.latLng.latitude, lng: $0.latLng.longitude)
            let marker = NMFMarker(position: latLng)
            if !markersPosition.contains(latLng) {
                markerArray.append(marker)
            }
        }
    }
    
    private func updateMarkers(mapView: NMFMapView) {
        convertMarkers()
        markerArray.forEach { marker in
            if mapView.contentBounds.hasPoint(marker.position) {
                marker.mapView = mapView
            } else {
                marker.mapView = nil
            }
        }
    }
    
    private func filterScreenWalkList(mapView: NMFMapView) {
         screenWalkList = walkRepository.walkList.filter {
            let latLng = NMGLatLng(lat: $0.latLng.latitude, lng: $0.latLng.longitude)
            return mapView.contentBounds.hasPoint(latLng)
        }
    }
    
    func configureViewModel(mapView: NMFMapView) {
        updateMarkers(mapView: mapView)
        filterScreenWalkList(mapView: mapView)
    }
}
