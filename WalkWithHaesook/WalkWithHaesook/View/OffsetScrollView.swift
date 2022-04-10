//
//  OffsetScrollView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/04/10.
//

import SwiftUI

struct OffsetScrollView<Content: View>: View {
    let axis: Axis.Set
    let showIndicator: Bool
    let offsetChanged: (CGFloat) -> Void
    let content: Content
    
    init(axis: Axis.Set = .horizontal,
         showIndicator: Bool = false,
         offsetChanged: @escaping (CGFloat) -> Void,
         @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.showIndicator = showIndicator
        self.offsetChanged = offsetChanged
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axis, showsIndicators: showIndicator) {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: OffsetScrollViewPreferenceKey.self,
                    value: axis == .horizontal ?
                    -(proxy.frame(in: .global).minX) / UIScreen.main.bounds.width :
                    -(proxy.frame(in: .global).minY) / UIScreen.main.bounds.height )
            }
            .frame(height: .zero)
            content
        }
        .onPreferenceChange(OffsetScrollViewPreferenceKey.self, perform: offsetChanged)
    }
}

struct OffsetScrollViewPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
