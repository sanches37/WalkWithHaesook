//
//  MapViewModel.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import NMapsMap
import Combine

class MapViewModel: ObservableObject {
    let walkRepository = WalkRepository()
    let mapView = NMFMapView()
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    @Published var userLocation: NMGLatLng?
    @Published var permissionDenied = false
    @Published var listViewModel: ListViewModel?
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
                $0.infoWindow.dataSource = CustomInfoWindowView(title: $0.title)
                $0.infoWindow.zIndex = .zero
                $0.infoWindow.invalidate()
            }
        }
    }
    
    func setUpListViewModel(id: String) {
        walkRepository.$walk
            .combineLatest($userLocation.first())
            .map { (walkList, userLocation) -> ListViewModel? in
                guard let index = walkList.firstIndex(where: { $0.id == id }) else {
                   return nil
                }
                let latLng = NMGLatLng(
                    lat: walkList[index].latLng.latitude,
                    lng: walkList[index].latLng.longitude)
                guard let distance = userLocation?.distance(to: latLng) else {
                    return ListViewModel(walk: walkList[index],
                                         distance: nil)
                }
                return ListViewModel(walk: walkList[index],
                                     distance: distance.withMeter)
            }
            .assign(to: \.listViewModel, on: self)
            .store(in: &cancellables)
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
}
