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
    @Published var updateMapView: NMFMapView?
    @Published var selectedInfoWindow: NMFInfoWindow?
    @Published var selectedListViewModelID: String?
    @Published var selectedListViewModelIndex: Int?
    
    init() {
        getUserLocation()
        setUpListViewModel()
        setUpMarkerViewModel()
        setUpSelectedListViewModelID()
        //        setUpSelectedInfoWindow()
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
    
    private func setUpListViewModel() {
        walkRepository.$walk
            .combineLatest($userLocation, $updateMapView)
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
    
    private func setUpSelectedListViewModelID() {
        $selectedInfoWindow
            .sink { selectedInfoWindow in
                guard let id = selectedInfoWindow?.userInfo["id"] as? String else {
                    self.selectedListViewModelID = nil
                    return
                }
                self.selectedListViewModelID = id
            }
            .store(in: &cancellables)
    }
    
    //    private func setUpSelectedInfoWindow() {
    //        $selectedListViewModelIndex
    //            .removeDuplicates()
    //            .combineLatest($listViewModel, $markerViewModel)
    //            .sink { (index, listViewModel, markerViewModel) in
    //                guard let index = index else {
    //                    self.selectedListViewModelID = nil
    //                    return }
    //                self.selectedListViewModelID = listViewModel[index].id
    //                guard let markerIndex = markerViewModel.firstIndex(where: { $0.id == listViewModel[index].id }) else { return }
    //                self.selectedInfoWindow = markerViewModel[markerIndex].infoWindow
    //            }
    //            .store(in: &cancellables)
    //    }
}
