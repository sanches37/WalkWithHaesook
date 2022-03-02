//
//  WalkViewModel.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/02.
//

import Combine
import NMapsMap

class WalkViewModel: ObservableObject {
    @Published var walkList: WalkList
    private var cancellable: AnyCancellable?
    let distance: NMGLatLng
    var id = ""
    
    init(walkList: WalkList) {
        self.walkList = walkList
        self.distance = NMGLatLng(
            lat: walkList.latLng.latitude, lng: walkList.latLng.longitude)
        cancellable = $walkList
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
    }
}
