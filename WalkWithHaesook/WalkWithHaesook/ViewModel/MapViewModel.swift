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
    private var cancellables = Set<AnyCancellable>()
    let mapView = NMFMapView()
    @Published var userLocation: NMGLatLng?
    @Published var permissionDenied = false
    @Published var tableViewModel: [TableViewModel] = []
    @Published var markerViewModel: [MarkerViewModel] = []
    
    init() {
        getUserLocation()
        setUpMarkerViewModel()
    }
    
    private func getUserLocation() {
        locationManager.locationSubject.sink { location in
            if let location = location {
                self.userLocation = NMGLatLng(lat: location.coordinate.latitude,
                                              lng: location.coordinate.longitude)
            } else {
                self.permissionDenied = true
            }
        }
        .store(in: &cancellables)
    }
    
    func focusLocation() {
        guard let userLocation = userLocation else { return }
        mapView.positionMode = .direction
        let cameraUpdate = NMFCameraUpdate(scrollTo: userLocation)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        mapView.moveCamera(cameraUpdate)
    }
    
    func UpdateInfoWindow(selectedInfoWindow: NMFInfoWindow? = nil) {
        markerViewModel.forEach {
            if $0.infoWindow != selectedInfoWindow {
                $0.infoWindow.dataSource = CustomInfoWindowDataSource(title: $0.title)
                $0.infoWindow.invalidate()
            }
        }
    }
    
    private func setUpMarkerViewModel() {
        walkRepository.$walk
            .map { walkList -> [MarkerViewModel] in
                walkList.map { walk -> MarkerViewModel in
                    let latLng = NMGLatLng(
                        lat: walk.latLng.latitude,
                        lng: walk.latLng.longitude)
                    let marker = NMFMarker(position: latLng)
                    let infoWindow = NMFInfoWindow()
                    return MarkerViewModel(
                        marker: marker,
                        infoWindow: infoWindow,
                        walk: walk)
                }
            }
            .assign(to: \.markerViewModel, on: self)
            .store(in: &cancellables)
    }
    
    private func setUpTableViewModel(mapView: NMFMapView) {
        walkRepository.$walk
            .combineLatest($userLocation)
            .map { (walkList, userLocation) -> [TableViewModel] in
                walkList.compactMap { walk -> TableViewModel? in
                    let latLng = NMGLatLng(
                        lat: walk.latLng.latitude,
                        lng: walk.latLng.longitude)
                    guard let distance = userLocation?.distance(to: latLng) else { return nil }
                    return TableViewModel(
                        walk: walk,
                        latLng: latLng,
                        distance: String(distance))
                }
            }
            .assign(to: \.tableViewModel, on: self)
            .store(in: &cancellables)
    }
}
