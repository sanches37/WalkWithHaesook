//
//  LatLngDummy.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import Foundation
import NMapsMap

struct LatLngDummy {
    var latLng: [NMGLatLng]
    
    init() {
        latLng = [
            NMGLatLng(lat: 37.368456, lng: 127.130183),
            NMGLatLng(lat: 37.367456, lng: 127.139183),
            NMGLatLng(lat: 37.366456, lng: 127.13183),
            NMGLatLng(lat: 37.365456, lng: 127.138183),
            NMGLatLng(lat: 37.364456, lng: 127.141183)
        ]
    }
}

struct WalkList: Decodable {
    
}
