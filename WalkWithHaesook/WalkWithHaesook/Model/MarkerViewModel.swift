//
//  MarkerViewModel.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/03.
//

import Foundation
import NMapsMap

struct MarkerViewModel: Identifiable {
    let marker: NMFMarker
    let infoWindow: NMFInfoWindow
    let title: String
    let id: String
    
    init(marker: NMFMarker, infoWindow: NMFInfoWindow, walk: Walk) {
        self.marker = marker
        self.infoWindow = infoWindow
        self.title = walk.title
        self.id = walk.id ?? ""
    }
}
