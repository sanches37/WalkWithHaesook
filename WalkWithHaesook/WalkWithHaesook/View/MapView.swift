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
    
    func makeUIView(context: Context) -> NMFMapView {
        let view = mapViewModel.mapView
        view.mapType = .basic
        view.addCameraDelegate(delegate: context.coordinator)
        return view
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        if uiView.positionMode == .disabled {
            mapViewModel.focusLocation()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        MapView.Coordinator()
    }
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        private let mapViewModel = MapViewModel()
        func mapViewCameraIdle(_ mapView: NMFMapView) {
            mapViewModel.configureViewModel(mapView: mapView)
        }
    }
}
