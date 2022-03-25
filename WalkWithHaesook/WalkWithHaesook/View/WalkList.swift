//
//  WalkTable.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/02.
//

import SwiftUI
import Kingfisher

struct WalkList: View {
    var listViewModel: ListViewModel?
    var body: some View {
        if let listViewModel = listViewModel {
            HStack {
                KFImage(URL(string: listViewModel.walk.thumnail))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 3, height: 90)
                VStack(alignment: .leading, spacing: 10) {
                    Text(listViewModel.walk.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    Text(listViewModel.distance)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .background(Color.white)
            .frame(width: UIScreen.main.bounds.width, height: 90)
            .padding()
        }
    }
}
