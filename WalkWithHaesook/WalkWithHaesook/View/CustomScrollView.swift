//
//  CustomScrollView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/04/04.
//

import SwiftUI

struct CustomScrollView<Content: View>: UIViewRepresentable {
    @ObservedObject var mapViewModel: MapViewModel
    var content: Content
    let scrollView = UIScrollView()
    let rect: CGRect
    
    init(mapViewModel: MapViewModel, rect: CGRect, @ViewBuilder content: () -> Content) {
        self.mapViewModel = mapViewModel
        self.content = content()
        self.rect = rect
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        setUpScrollView()
        scrollView.addSubview(extractView())
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    private func setUpScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize =
        CGSize(width: rect.width * CGFloat(mapViewModel.listViewModel.count),
               height: rect.height)
    }
    
    private func extractView() -> UIView {
        let contentView = UIHostingController(rootView: content)
        contentView.view.frame =
        CGRect(x: 0, y: 0,
               width: rect.width * CGFloat(mapViewModel.listViewModel.count),
               height: rect.height)
        contentView.view.sizeToFit()
        contentView.view.backgroundColor = .clear
        return contentView.view
    }
}
