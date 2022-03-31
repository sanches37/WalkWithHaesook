//
//  DetailView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/28.
//

import SwiftUI

struct DetailView: View {
    var detailViewModel: DetailViewModel
    @State var isPlaying = false
    @State var showPlayButton = false
    var body: some View {
        VStack {
            ZStack {
                PlayerView(player: detailViewModel.video)
                    .frame(height: UIScreen.main.bounds.height / 1.3)
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
        .applyDetailViewTitle(detailViewModel.title ?? "")
        .onAppear {
            detailViewModel.video?.play()
            detailViewModel.video == nil ? (isPlaying = false) : (isPlaying = true)
        }
        .onDisappear {
            detailViewModel.video?.replaceCurrentItem(with: nil)
        }
    }
}

extension View {
    @ViewBuilder
    func applyDetailViewTitle(_ title: String) -> some View {
        if #available(iOS 14.0, *) {
            self.navigationTitle(title)
        } else {
            self.navigationBarTitle(title)
        }
    }
}
