//
//  DetailView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/28.
//

import SwiftUI

struct DetailView: View {
    var detailViewModel: DetailViewModel
    var body: some View {
        VStack {
            PlayerView(player: detailViewModel.video)
                .frame(height: UIScreen.main.bounds.height / 1.3)
            Text(detailViewModel.description ?? "")
                .padding(.horizontal)
            Spacer()
        }
        .applyDetailViewTitle(detailViewModel.title ?? "")
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
