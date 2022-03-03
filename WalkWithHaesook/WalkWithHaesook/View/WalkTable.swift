//
//  WalkTable.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/02.
//

import SwiftUI
import Kingfisher

struct WalkTable: View {
    var tableViewModel: TableViewModel
    var body: some View {
        HStack {
            KFImage(URL(string: tableViewModel.walk.thumnail))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width / 3, height: 90)
            VStack(alignment: .leading, spacing: 10) {
                Text(tableViewModel.walk.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Text(tableViewModel.distance)
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
