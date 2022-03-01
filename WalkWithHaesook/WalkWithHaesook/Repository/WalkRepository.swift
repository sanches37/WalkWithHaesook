//
//  WalkRepository.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/28.
//

import Combine

class WalkRepository {
    private let fireStoreManager = FireStoreManager()
    @Published var walkList: [WalkList] = []
    
    init() {
        getFireStoreData()
    }
    
    private func getFireStoreData() {
        fireStoreManager.fetch { (result: Result<[WalkList], FireStoreError>) in
            switch result {
            case .success(let data):
                self.walkList = data
            case .failure(let error):
                debugPrint(error.errorDescription)
            }
        }
    }
}
