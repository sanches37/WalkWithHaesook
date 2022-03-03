//
//  LatLngDummy.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Walk: Decodable {
    @DocumentID var id: String?
    let title: String
    let latLng: GeoPoint
    let thumnail: String
}
