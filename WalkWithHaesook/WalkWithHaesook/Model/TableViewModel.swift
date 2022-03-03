//
//  WalkViewModel.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/02.
//

import Foundation
import NMapsMap

struct TableViewModel: Identifiable {
    let walk: Walk
    let latLng: NMGLatLng
    let distance: String
    let id: String
    
    init(walk: Walk, latLng: NMGLatLng, distance: String) {
        self.walk = walk
        self.latLng = latLng
        self.distance = distance
        self.id = walk.id ?? ""
    }
}
