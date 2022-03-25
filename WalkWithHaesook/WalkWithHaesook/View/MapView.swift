//
//  MapView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import SwiftUI
import NMapsMap

struct MapView: UIViewRepresentable {
    @EnvironmentObject var mapViewModel: MapViewModel
    let markerImage = "juicy_fish_veterinarian_icon"
    
    func makeUIView(context: Context) -> NMFMapView {
        let view = mapViewModel.mapView
        view.mapType = .basic
        view.addCameraDelegate(delegate: context.coordinator)
        return view
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        if uiView.positionMode == .disabled {
            mapViewModel.focusLocation()
            setUpMarker()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        MapView.Coordinator(mapViewModel: mapViewModel)
    }
    
    private func setUpMarker() {
        let markerImage = NMFOverlayImage(name: markerImage)
        mapViewModel.markerViewModel.forEach {
            $0.marker.iconImage = markerImage
            $0.marker.width = 40
            $0.marker.height = 40
        }
    }
    
    class Coordinator: NSObject {
        private let mapViewModel: MapViewModel
        
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
            } else {
                $0.marker.mapView = nil
            }
        }
    }
}
