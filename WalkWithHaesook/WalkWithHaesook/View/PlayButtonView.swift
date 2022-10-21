//
//  PlayButtonView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/31.
//

import SwiftUI
import AVFoundation

struct PlayButtonView: View {
  var player: AVPlayer?
  @Binding var isPlaying: Bool
  
  var body: some View {
    Button {
      if isPlaying {
        self.player?.pause()
        self.isPlaying.toggle()
      } else {
        self.player?.play()
        self.isPlaying.toggle()
      }
    } label: {
      Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
        .font(.largeTitle)
        .foregroundColor(.white)
        .padding()
    }
  }
}
