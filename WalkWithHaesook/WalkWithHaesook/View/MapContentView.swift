//
//  ContentView.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/20.
//

import SwiftUI

struct MapContentView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @EnvironmentObject var detailViewModel: DetailViewModel
    var body: some View {
        NavigationView {
            ZStack {
                MapView(mapViewModel: mapViewModel)
                    .edgesIgnoringSafeArea(.vertical)
                VStack(spacing: .zero) {
                    Spacer()
                    Button {
                        mapViewModel.focusLocation = mapViewModel.userLocation
                    } label: {
                        Image(systemName: "scope")
                            .font(.body)
                            .padding(13)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                    if let listViewModel = mapViewModel.selectedListViewModel {
                        NavigationLink(
                            destination: DetailView()
                                .onDisappear {
                                    mapViewModel.selectedInfoWindow = nil
                                    mapViewModel.selectedListViewModel = nil
                                    mapViewModel.selectedListViewModelIndex = nil
                                }) {
                                    ListView(listViewModel: listViewModel)
                                }
                    }
                }
            }
            .applyContentViewTitle()
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

extension View {
    @ViewBuilder
    func applyContentViewTitle() -> some View {
        if #available(iOS 14.0, *) {
            self.navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            self.navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapContentView(mapViewModel: MapViewModel())
    }
}
