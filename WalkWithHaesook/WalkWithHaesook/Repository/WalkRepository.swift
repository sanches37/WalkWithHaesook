//
//  WalkRepository.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/28.
//

import Combine

class WalkRepository: ObservableObject {
  private let fireStoreManager = FireStoreManager()
  @Published var walk: [Walk] = []
  
  init() {
    getFireStoreData()
  }
  
  private func getFireStoreData() {
    fireStoreManager.fetch { (result: Result<[Walk], FireStoreError>) in
      switch result {
      case .success(let data):
//                self.walk = parkSample
        self.walk = data

      case .failure(let error):
        debugPrint(error.errorDescription)
      }
    }
  }
}
