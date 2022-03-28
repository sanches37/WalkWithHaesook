//
//  ContentView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mapViewModel: MapViewModel
    var body: some View {
        NavigationView {
            ZStack {
                MapView(mapViewModel: mapViewModel)
                    .edgesIgnoringSafeArea(.vertical)
                VStack(spacing: .zero) {
                    Spacer()
                    Button(action: mapViewModel.focusLocation) {
                        Image(systemName: "scope")
                            .font(.body)
                            .padding(13)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                    if let listViewModel = mapViewModel.listViewModel {
                        NavigationLink(destination: DetailView()) {
                            ListView(listViewModel: listViewModel)
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .alert(isPresented: $mapViewModel.permissionDenied) {
                let firstButton = Alert.Button.cancel((Text("취소")))
                let secondButton = Alert.Button.default(Text("설정")) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                return Alert(title: Text("위치 허용이 되지 않았습니다."),
                             message: Text("설정에서 위치 허용을 해주세요"),
                             primaryButton: firstButton,
                             secondaryButton: secondButton)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mapViewModel: MapViewModel())
    }
}
