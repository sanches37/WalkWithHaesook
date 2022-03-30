## 프로젝트 소개
* 반려견 해숙이와 함께하는 산책로 소개 어플
* 산책로 위치를 지도에서 선택하면, 해당 산책로의 영상을 볼 수 있도록 구현
<br/>

## 프로젝트 진행시 지키려고 한 사항
* IOS 13.0 이상 동작하도록 구현
* MVVM 패턴으로 구현
<br/>

![WalkWithHaesook mp4](https://user-images.githubusercontent.com/84059338/160789687-deae81b5-2c94-4577-9cd1-6c2a0092ac1e.gif)
<br/>

## Step1 - FireSotre 코드 구현 및 CLLocation을 이용한 사용자 위치 표시
* FireStore에서 가져온 Repository를 ViewModel에서 가공 후 View에서 적용
* 위치 거부시 alert을 통해 설정으로 이동할 수 있도록 구현
<br/>

## Step2 - 산책로 위치를 지도 내 마커로 표현
* 지도내에 존재하는 마커정보만 그려지고, 지도에서 벗어난 마커정보는 사라지도록 구현
* 마커 선택시 DetailView로 이동할 수 있는 ListView가 나타나도록 구현
<br/>

## Setp3 - 마커 클릭시 DetailView로 이동 후 산책로 동영상 재생
* DetailView로 이동시 영상이 자동재생되고, 다시 지도뷰로 이동시 영상이 해제되도록 구현
<br/>

## 사용기술
* SwiftUI
* Combine
* CLLocation
* AVKit
* FireStore
* 네이버 지도 SDK
* Kingfisher
* SwiftLint
<br/>

마커 이미지 저작권
<a href="https://www.flaticon.com/kr/premium-icon/veterinarian_5695709?term=%EB%A7%88%EC%BB%A4&related_id=5695709">수의사 아이콘  제작자: juicy_fish - Flaticon</a>
