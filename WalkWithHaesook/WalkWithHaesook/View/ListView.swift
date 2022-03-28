//
//  WalkTable.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/02.
//

import SwiftUI

struct ListView: View {
    var listViewModel: ListViewModel?
    var body: some View {
        if let listViewModel = listViewModel {
            HStack() {
                KFImageView(url: URL(string: listViewModel.thumnail))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width / 3.5,
                           height: UIScreen.main.bounds.width / 3.5)
                    .clipped()
                VStack(alignment: .leading, spacing: 15) {
                    Text(listViewModel.title)
                        .font(.body.bold())
                        .foregroundColor(.black)
                    Text(listViewModel.distance)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding([.bottom, .horizontal])
        }
    }
}
