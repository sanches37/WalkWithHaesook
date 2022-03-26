//
//  KFImage.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/26.
//

import SwiftUI
import Kingfisher

struct KFImageView: UIViewRepresentable {
    let url: Resource?
    
    func makeUIView(context: Context) -> UIImageView {
        return UIImageView()
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        guard let url = url else { return }
        uiView.kf.setImage(with: url)
    }
}
