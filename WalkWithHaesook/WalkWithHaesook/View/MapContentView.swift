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
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom)
                    .padding(.trailing, 20)
                    
                    if mapViewModel.selectedListViewModelID != nil {
                        ScrollViewReader { proxy in
                            OffsetScrollView { index in
                                mapViewModel.selectedListViewModelIndex = index
                            } content: {
                                LazyHStack(spacing: .zero) {
                                    ForEach(mapViewModel.listViewModel) { listViewModel in
                                        NavigationLink(
                                            destination: DetailView()
                                                .onDisappear {
                                                    mapViewModel.selectedInfoWindow = nil
                                                }) {
                                                    ListView(listViewModel: listViewModel)
                                                }
                                                .id(listViewModel.id)
                                    }
                                }
                            }
                            .frame(height: UIScreen.main.bounds.width / 3.2)
                            .onReceive(mapViewModel.$selectedListViewModelID, perform: { id in
                                    proxy.scrollTo(id)
                            })
                            .onAppear {
                                UIScrollView.appearance().isPagingEnabled = true
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $mapViewModel.permissionDenied) {
                let firstButton = Alert.Button.cancel((Text("??????")))
                let secondButton = Alert.Button.default(Text("??????")) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                return Alert(title: Text("?????? ????????? ?????? ???????????????."),
                             message: Text("???????????? ?????? ????????? ????????????"),
                             primaryButton: firstButton,
                             secondaryButton: secondButton)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapContentView(mapViewModel: MapViewModel())
    }
}
