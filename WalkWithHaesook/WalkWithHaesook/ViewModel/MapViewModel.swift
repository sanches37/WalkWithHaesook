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
  private let makerClusterManager = MakerClusterManager()
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
  @Published var zoomLevel: Double?
  @Published var allowableDistance: Double?
  @Published var markersOnTheScreen: [NMFMarker] = []
  @Published var northWestPositionOfBounds: NMGLatLng?
  @Published var markerClusterCenters: [MakerClusterModel] = []
  @Published var makerClusters: [[NMFMarker]] = []
  
  init() {
    getUserLocation()
    setUpListViewModel()
    setUpMarkerViewModel()
    updateSelectedListViewModelInfo()
    updateSelectedInfoWindowDueToUpdatedList()
    updateSelectedInfoWindowDueToListScroll()
    getMakerClusterViewModel()
    getAllowableDistanceByZoomLevel()
  }
  
  private func getAllowableDistanceByZoomLevel() {
    $zoomLevel
      .sink {
        guard let result = $0 else { return }
        switch result {
        case 6..<7:
          self.allowableDistance = 50000
        case 7..<8:
          self.allowableDistance = 30000
        case 8..<9:
          self.allowableDistance = 20000
        case 9..<9.5:
          self.allowableDistance = 12000
        case 9.5..<10:
          self.allowableDistance = 8000
        default:
          self.allowableDistance = nil
        }
      }
      .store(in: &cancellables)
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
      .combineLatest($updateMapView)
      .map { (walkList, mapView) -> [ListViewModel] in
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
          guard let distance = self.userLocation?.distance(to: latLng) else {
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
  
  private func updateSelectedListViewModelInfo() {
    $selectedInfoWindow
      .sink { selectedInfoWindow in
        guard let id = selectedInfoWindow?.userInfo["id"] as? String,
              let index = self.listViewModel.firstIndex(where: {
                $0.id == id
              }) else {
          self.selectedListViewModelID = nil
          self.selectedListViewModelIndex = nil
          return
        }
        self.selectedListViewModelID = id
        self.selectedListViewModelIndex = index
      }
      .store(in: &cancellables)
  }
  
  private func updateSelectedInfoWindowDueToUpdatedList() {
    $listViewModel
      .combineLatest($selectedInfoWindow.first())
      .debounce(for: 0.01, scheduler: RunLoop.main)
      .sink { _ in
        guard let id = self.selectedListViewModelID,
              let markerIndex = self.markerViewModel.firstIndex(where: {
                $0.id == id
              }) else { return }
        self.selectedInfoWindow = self.markerViewModel[markerIndex].infoWindow
      }
      .store(in: &cancellables)
  }
  
  private func updateSelectedInfoWindowDueToListScroll() {
    $selectedListViewModelIndex
      .removeDuplicates()
      .debounce(for: 0.02, scheduler: RunLoop.main)
      .sink { index in
        guard let index = index,
              self.listViewModel.indices.contains(index),
              let markerIndex = self.markerViewModel.firstIndex(where: {
                $0.id == self.listViewModel[index].id
              }) else { return }
        self.selectedInfoWindow = self.markerViewModel[markerIndex].infoWindow
      }
      .store(in: &cancellables)
  }
  
  private func getMakerClusterViewModel() {
    $markersOnTheScreen
      .zip($northWestPositionOfBounds)
      .sink { makers, northWest in
        guard let northWest = northWest else {
          return
        }
        self.makerClusterManager.getCluster(
          makers: makers,
          basePosition: northWest,
          allowableDistance: self.allowableDistance) { centers, clusters in
            self.markerClusterCenters = centers
            self.makerClusters = clusters
          }
      }
      .store(in: &cancellables)
  }
}

extension CurrentValueSubject where Output == Void {
  func sink(receiveCompletion: @escaping ((Subscribers.Completion<Failure>) -> Void)) -> AnyCancellable {
    sink(receiveCompletion: receiveCompletion, receiveValue: {})
  }
}
