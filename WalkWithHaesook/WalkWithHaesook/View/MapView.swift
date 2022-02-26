//
//  MapView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import SwiftUI
import NMapsMap

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> NMFMapView {
        let view = NMFMapView()
        view.mapType = .basic
        view.addCameraDelegate(delegate: context.coordinator)
        return view
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        MapView.Coordinator()
    }
    
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
    }
}

