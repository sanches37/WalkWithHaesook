//
//  WalkWithHaesook.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/04/08.
//

import SwiftUI
import Firebase

@main
struct WalkWithHaesookApp: App {
  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      let mapViewModel = MapViewModel()
      MapContentView(mapViewModel: mapViewModel)
        .environmentObject(DetailViewModel(mapViewModel: mapViewModel))
    }
  }
}
