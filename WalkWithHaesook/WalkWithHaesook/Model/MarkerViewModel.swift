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
    let title: String
    let id: String
    
    init(marker: NMFMarker, walk: Walk) {
        self.marker = marker
        self.title = walk.title
        self.id = walk.id ?? ""
    }
}
