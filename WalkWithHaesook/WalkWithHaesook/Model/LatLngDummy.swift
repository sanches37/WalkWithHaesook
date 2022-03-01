//
//  LatLngDummy.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import Foundation
import FirebaseFirestore

struct WalkList: Decodable {
    let latLng: GeoPoint
}
