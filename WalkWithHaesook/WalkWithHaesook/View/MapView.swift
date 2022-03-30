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
        view.addCameraDelegate(delegate: context.coordinator)
        view.touchDelegate = context.coordinator
        setUp(context: context)
        return view
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        MapView.Coordinator(mapViewModel: mapViewModel)
    }
    
    func setUp(context: Context) {
        mapViewModel.$userLocation
            .first { $0 != nil }
            .sink { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    setUpMarker()
                    mapViewModel.UpdateInfoWindow()
                    mapViewModel.focusLocation()
                }
            }
            .store(in: &context.coordinator.cancellable)
    }
    
    private func setUpMarker() {
        let markerImage = NMFOverlayImage(name: markerImage)
        mapViewModel.markerViewModel.forEach {
            $0.marker.iconImage = markerImage
            $0.marker.width = 40
            $0.marker.height = 40
            $0.marker.touchHandler = markerHandler()
            $0.infoWindow.touchHandler = markerHandler()
            $0.infoWindow.userInfo = ["title": $0.title,
                                      "id": $0.id ]
        }
    }
    
    private func markerHandler() -> (NMFOverlay) -> Bool {
        let handler = { (overlay: NMFOverlay) -> Bool in
            if let marker = overlay as? NMFMarker,
               let infoWindow = marker.infoWindow {
                selectOverlay(infoWindow: infoWindow)
                mapViewModel.UpdateInfoWindow(selectedInfoWindow: infoWindow)
            }
            if let infoWindow = overlay as? NMFInfoWindow {
                selectOverlay(infoWindow: infoWindow)
                mapViewModel.UpdateInfoWindow(selectedInfoWindow: infoWindow)
            }
            return true
        }
        return handler
    }
    
    private func selectOverlay(infoWindow: NMFInfoWindow) {
        if let title = infoWindow.userInfo["title"] as? String,
           let marker = infoWindow.marker {
            infoWindow.dataSource = CustomInfoWindowView(title: title,
                                                         status: .selected)
            infoWindow.zIndex = 1
            infoWindow.open(with: marker)
        }
        if let id = infoWindow.userInfo["id"] as? String {
            mapViewModel.setUpListViewModel(id: id)
        }
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
        updateMarkers(mapView: mapView)
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
}

extension MapView.Coordinator: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        mapViewModel.UpdateInfoWindow()
        mapViewModel.listViewModel = nil
    }
}
