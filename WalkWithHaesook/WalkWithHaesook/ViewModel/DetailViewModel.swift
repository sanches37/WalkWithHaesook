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
    
    private func setUp() {
        mapViewModel.walkRepository.$walk
            .combineLatest( mapViewModel.$selectedListViewModelID)
            .sink { walkList, id in
                guard let index = walkList.firstIndex(where: { $0.id == id }),
                      let url = URL(string: walkList[index].video) else {
                    return
                }
                self.title = walkList[index].title
                self.video = AVPlayer(url: url)
                self.description = walkList[index].description
            }
            .store(in: &cancellables)
    }
}
