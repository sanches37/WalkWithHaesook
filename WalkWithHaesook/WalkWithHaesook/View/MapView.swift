//
//  MapView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import SwiftUI
import NMapsMap
import Combine

struct MapView: UIViewRepresentable {
  @ObservedObject var mapViewModel: MapViewModel
  private let markerImage = "juicy_fish_veterinarian_icon"
  
  func makeUIView(context: Context) -> NMFMapView {
    let view = mapViewModel.mapView
    view.zoomLevel = 11
    view.minZoomLevel = 6
    view.addCameraDelegate(delegate: context.coordinator)
    view.touchDelegate = context.coordinator
    setUp(context: context, mapView: view)
    return view
  }
  
  func updateUIView(_ uiView: NMFMapView, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    MapView.Coordinator(mapViewModel: mapViewModel)
  }
  
  private func setUp(context: Context, mapView: NMFMapView) {
    setUpMarker(context: context)
    setUpFocusLocation(context: context, mapView: mapView)
    updateFocusLocation(context: context)
    updateInfoWindow(context: context)
    updateClusterInfoWindow(context: context, mapView: mapView)
  }
  
  private func setUpMarker(context: Context) {
    let markerImage = NMFOverlayImage(name: markerImage)
    mapViewModel.$markerViewModel
      .first { $0.isEmpty == false }
      .sink {
        $0.forEach {
          $0.marker.iconImage = markerImage
          $0.marker.width = 40
          $0.marker.height = 40
          $0.marker.touchHandler = markerHandler()
          $0.infoWindow.touchHandler = markerHandler()
          $0.infoWindow.userInfo = ["id": $0.id ]
        }
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  private func setUpFocusLocation(context: Context, mapView: NMFMapView) {
    mapViewModel.$focusLocation
      .sink {
        guard let focusLocation = $0 else { return }
        mapView.positionMode = .direction
        let cameraUpdate = NMFCameraUpdate(scrollTo: focusLocation)
        mapView.moveCamera(cameraUpdate)
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  private func updateFocusLocation(context: Context) {
    mapViewModel.$userLocation
      .first { $0 != nil }
      .sink {
        mapViewModel.focusLocation = $0
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  private func updateInfoWindow(context: Context) {
    mapViewModel.$markerViewModel
      .first { $0.isEmpty == false }
      .combineLatest(mapViewModel.$selectedInfoWindow)
      .sink { (markerViewModel, selectedInfoWindow) in
        markerViewModel.forEach {
          if $0.infoWindow == selectedInfoWindow {
            $0.infoWindow.dataSource = CustomInfoWindowView(title: $0.title,
                                                            status: .selected)
            $0.infoWindow.zIndex = 1
            $0.infoWindow.invalidate()
          } else {
            $0.infoWindow.dataSource = CustomInfoWindowView(title: $0.title)
            $0.infoWindow.zIndex = .zero
            $0.infoWindow.invalidate()
          }
        }
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  private func markerHandler() -> (NMFOverlay) -> Bool {
    let handler = { (overlay: NMFOverlay) -> Bool in
      if let marker = overlay as? NMFMarker,
         let infoWindow = marker.infoWindow {
        mapViewModel.selectedInfoWindow = infoWindow
      }
      if let infoWindow = overlay as? NMFInfoWindow {
        mapViewModel.selectedInfoWindow = infoWindow
      }
      return true
    }
    return handler
  }
  
  private func updateClusterInfoWindow(context: Context, mapView: NMFMapView) {
    
    mapViewModel.$markerClusterCenters
      .sink { clusters in
        clusters.forEach {
          $0.infoWindow.dataSource = ClusterInfoWindowView(title: "\($0.makerCount)")
          $0.infoWindow.position = $0.centroid
          $0.infoWindow.zIndex = 2
          $0.circle.center = $0.centroid
          $0.circle.radius = mapViewModel.allowableDistance ?? 0
          $0.circle.fillColor = UIColor.blue.withAlphaComponent(0.5)
          $0.circle.mapView = mapView
          $0.infoWindow.open(with: mapView)
          print("open: \($0.makerCount)")
        }
      }
      .store(in: &context.coordinator.cancellable)
  }
  
  class Coordinator: NSObject {
    private let mapViewModel: MapViewModel
    var cancellable = Set<AnyCancellable>()
    
    init(mapViewModel: MapViewModel) {
      self.mapViewModel = mapViewModel
    }
  }
}

extension MapView.Coordinator: NMFMapViewCameraDelegate {
  func mapViewCameraIdle(_ mapView: NMFMapView) {
    getZoomLevel(mapView: mapView)
    updateMarkers(mapView: mapView)
    removeClusterInfoWindow {
      self.getMakersOnTheScreen(mapView: mapView)
      self.getNorthWestPositionOfBounds(mapView: mapView)
    }
    mapViewModel.updateMapView = mapView
    deleteSelectedMarker(mapView: mapView)
  }
  
  private func getMakersOnTheScreen(mapView: NMFMapView) {
    mapViewModel.markersOnTheScreen = mapViewModel.markerViewModel
      .filter { mapView.contentBounds.hasPoint($0.marker.position) }
      .map(\.marker)
  }
  
  private func getNorthWestPositionOfBounds(mapView: NMFMapView) {
    mapViewModel.northWestPositionOfBounds =
    NMGLatLng(lat: mapView.contentBounds.northEastLat,
              lng: mapView.contentBounds.southWestLng
    )
  }
  
  private func removeClusterInfoWindow(completion: @escaping () -> Void) {
    mapViewModel.markerClusterCenters.forEach {
      $0.circle.mapView = nil
      $0.infoWindow.close()
      print("remove: \($0.makerCount)")
    }
    completion()
  }
  
  private func updateMarkers(mapView: NMFMapView) {
    mapViewModel.markerViewModel.forEach {
      if mapView.contentBounds.hasPoint($0.marker.position) {
        $0.marker.mapView = mapView
        $0.infoWindow.open(with: $0.marker)
      } else {
        $0.marker.mapView = nil
        $0.infoWindow.close()
      }
    }
  }
  
  private func deleteSelectedMarker(mapView: NMFMapView) {
    guard let selectedId = mapViewModel.selectedListViewModelID,
          let index = mapViewModel.markerViewModel.firstIndex(where: {
            $0.id == selectedId }) else { return }
    if mapView.contentBounds.hasPoint(
      mapViewModel.markerViewModel[index].marker.position) == false {
      mapViewModel.selectedInfoWindow = nil
    }
  }
  
  private func getZoomLevel(mapView: NMFMapView) {
    mapViewModel.zoomLevel = mapView.zoomLevel
    print(mapViewModel.zoomLevel)
  }
}

extension MapView.Coordinator: NMFMapViewTouchDelegate {
  func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    mapViewModel.selectedInfoWindow = nil
  }
}
