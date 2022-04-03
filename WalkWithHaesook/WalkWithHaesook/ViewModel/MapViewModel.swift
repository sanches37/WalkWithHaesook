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
    @Published var focusLocation: NMGLatLng?
    @Published var listViewModel: [ListViewModel] = []
    @Published var markerViewModel: [MarkerViewModel] = []
    @Published var updateNMFMapView: NMFMapView?
    @Published var selectedInfoWindow: NMFInfoWindow?
    @Published var selectedListViewModel: ListViewModel?
    
    init() {
        getUserLocation()
        setUpFocusLocation()
        setUpListViewModel()
        setUpMarkerViewModel()
        setUpSelectedListViewModel()
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
    
    private func setUpFocusLocation() {
        $focusLocation
            .sink {
                guard let focusLocation = $0 else { return }
                self.mapView.positionMode = .direction
                let cameraUpdate = NMFCameraUpdate(scrollTo: focusLocation)
                cameraUpdate.animation = .easeIn
                cameraUpdate.animationDuration = 1
                self.mapView.moveCamera(cameraUpdate)
            }
            .store(in: &cancellables)
    }
    
    private func setUpListViewModel() {
        walkRepository.$walk
            .combineLatest($userLocation, $updateNMFMapView)
            .map { (walkList, userLocation, mapView) -> [ListViewModel] in
                walkList.filter {
                    let latLng = NMGLatLng(
                        lat: $0.latLng.latitude,
                        lng: $0.latLng.longitude)
                    guard let mapView = mapView else { return false }
                    return mapView.contentBounds.hasPoint(latLng)
                }
                .map { walk -> ListViewModel in
                    let latLng = NMGLatLng(
                        lat: walk.latLng.latitude,
                        lng: walk.latLng.longitude)
                    guard let distance = userLocation?.distance(to: latLng) else {
                        return ListViewModel(walk: walk, distance: nil)
                    }
                    return ListViewModel(walk: walk, distance: distance.withMeter)
                }
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
    
    private func setUpSelectedListViewModel() {
        $listViewModel
            .combineLatest($selectedInfoWindow)
            .sink { (listViewModel, selectedInfoWindow) in
                guard let id = selectedInfoWindow?.userInfo["id"] as? String,
                      let index = listViewModel.firstIndex(where: { $0.id == id }) else {
                    return
                }
                self.selectedListViewModel = listViewModel[index]
            }
            .store(in: &cancellables)
    }
}
