//
//  MakerClusterModel.swift
//  WalkWithHaesook
//
//  Created by linkey on 2022/10/26.
//

import Foundation
import NMapsMap

struct MakerClusterModel {
  let id = UUID()
  let centroid: NMGLatLng
  let infoWindow: NMFInfoWindow
  let makerCount: Int
  let circle: NMFCircleOverlay
}
