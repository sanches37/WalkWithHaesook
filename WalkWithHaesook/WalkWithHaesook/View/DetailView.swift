//
//  DetailView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/28.
//

import SwiftUI

struct DetailView: View {
  @EnvironmentObject var detailViewModel: DetailViewModel
  @State var isPlaying = false
  @State var showPlayButton = false
  var body: some View {
    VStack {
      ZStack {
        PlayerView(player: detailViewModel.video)
          .frame(width: UIScreen.main.bounds.width,
                 height: UIScreen.main.bounds.height / 1.3)
        if self.showPlayButton {
          PlayButtonView(player: detailViewModel.video,
                         isPlaying: $isPlaying)
        }
      }
      .onTapGesture {
        self.showPlayButton.toggle()
      }
      Text(detailViewModel.description ?? "")
        .padding(.horizontal)
      Spacer()
    }
    .navigationTitle(detailViewModel.title ?? "")
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      detailViewModel.video?.play()
      detailViewModel.video == nil ? (isPlaying = false) : (isPlaying = true)
    }
    .onDisappear {
      detailViewModel.video?.replaceCurrentItem(with: nil)
    }
  }
}
