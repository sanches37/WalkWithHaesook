//
//  DetailView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/28.
//

import SwiftUI
import AVKit

struct DetailView: View {
    @State var player = AVPlayer(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!)
    
    var body: some View {
        VStack {
            PlayerView(player: $player)
                .frame(height: UIScreen.main.bounds.height / 1.5)
            Spacer()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
