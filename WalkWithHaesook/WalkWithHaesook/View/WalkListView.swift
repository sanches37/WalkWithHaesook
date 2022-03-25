//
//  WalkTable.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/02.
//

import SwiftUI
import Kingfisher

struct WalkListView: View {
    var listViewModel: ListViewModel?
    var body: some View {
        if let listViewModel = listViewModel {
            HStack() {
                KFImage(URL(string: listViewModel.walk.thumnail))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 3.5,
                           height: UIScreen.main.bounds.width / 3.5)
                VStack(alignment: .leading, spacing: 15) {
                    Text(listViewModel.walk.title)
                        .fontWeight(.heavy)
                        .font(.body)
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
