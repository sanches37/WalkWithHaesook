//
//  WalkViewModel.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/02.
//

import Foundation

struct ListViewModel: Identifiable {
    let thumnail: String
    let title: String
    let distance: String
    let id: String
    
    init(walk: Walk, distance: String?) {
        self.thumnail = walk.thumnail
        self.title = walk.title
        self.distance = distance ?? ""
        self.id = walk.id ?? ""
    }
}
