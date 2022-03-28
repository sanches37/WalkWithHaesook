//
//  DetailViewModel.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/28.
//

import Combine
import AVFoundation

class DetailViewModel: ObservableObject {
    let mapViewModel: MapViewModel
    private var cancellables = Set<AnyCancellable>()
    @Published var title: String?
    @Published var video: AVPlayer?
    @Published var description: String?
    
    init(mapViewModel: MapViewModel) {
        self.mapViewModel = mapViewModel
        
        setUp()
    }
    
    func setUp() {
        mapViewModel.walkRepository.$walk
            .combineLatest( mapViewModel.$listViewModel)
            .sink { walkList, listViewModel in
                guard let index = walkList.firstIndex(where: { $0.id == listViewModel?.id }),
                      let url = URL(string: walkList[index].video) else {
                    return
                }
                self.title = listViewModel?.title
                self.video = AVPlayer(url: url)
                self.description = walkList[index].description
            }
            .store(in: &cancellables)
    }
}
