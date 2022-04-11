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
                    .padding()
                    
                    if mapViewModel.selectedListViewModelID != nil {
                        ScrollViewReader { proxy in
                            OffsetScrollView { index in
                                mapViewModel.selectedListViewModelIndex = index
                                print(index)
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
                                withAnimation {
                                    proxy.scrollTo(id)
                                }
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
        MapContentView(mapViewModel: MapViewModel())
    }
}
