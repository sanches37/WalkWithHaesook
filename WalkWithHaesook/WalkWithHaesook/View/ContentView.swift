//
//  ContentView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    var body: some View {
        ZStack {
            MapView()
            VStack {
                Spacer()
                Button(action: mapViewModel.focusLocation) {
                    Image(systemName: "scope")
                        .font(.body)
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
