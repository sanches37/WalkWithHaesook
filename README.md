### 프로젝트 소개
* 반려견 해숙이와 함께하는 산책로 소개 어플
* 산책로 위치를 지도에서 선택하면, 해당 산책로의 영상을 볼 수 있도록 구현
<br/>

### 프로젝트 진행시 지키려고 한 사항
* iOS 14.0이상 동작하도록 구현   
* MVVM 패턴으로 구현
<br/>

<img src = "https://user-images.githubusercontent.com/84059338/160789687-deae81b5-2c94-4577-9cd1-6c2a0092ac1e.gif" width="250"> &nbsp;&nbsp;&nbsp;&nbsp; <img src = "https://user-images.githubusercontent.com/84059338/162907197-ed33d5f7-a200-464d-9ece-ef283394efc5.gif" width="250">
<br/>

### Step1 - Firestore 코드 구현 및 CLLocation을 이용한 사용자 위치 표시
* Firestore에서 가져온 Repository를 ViewModel에서 가공 후 View에서 적용
* 위치 거부시 alert을 통해 설정으로 이동할 수 있도록 구현
<br/>

### Step2 - 산책로 위치를 지도 내 마커로 표현
* 지도내에 존재하는 마커정보만 그려지고, 지도에서 벗어난 마커정보는 사라지도록 구현
* 마커 선택시 DetailView로 이동할 수 있는 ListView가 나타나도록 구현
<br/>

### Setp3 - 마커 클릭시 DetailView로 이동 후 산책로 동영상 재생
* DetailView로 이동시 영상이 자동재생되고, 다시 지도뷰로 이동시 영상이 해제되도록 구현
<br/>

### Setp4 - IOS14.0으로 최소 버전 설정 및 ListView를 배열 형태로 변경
* ListView와 Marker가 서로 연동되게 동작하도록 구현
<br/>

### MakerCluster - zoomLevel 10이하에서 makerCluster 적용
* 화면의 북서쪽 지점을 startPoint로 잡고, startPoint에서 거리가 가까운 maker순으로 array를 생성
* array 순서대로 for문을 돌면서 zoomLevel별 지정된 범위로 첫 clusterCenter를 구함
* 구해진 clusterCenter로 가까운 maker를 모아서 다시 center를 구함 -> 중심 좌표가 변하지 않을때까지 반복하여 최종 clusterCenter를 구함
<img src = "https://user-images.githubusercontent.com/84059338/200486782-4329b04d-4e5b-426f-bc49-81e6a2b4471b.gif" width="250">

### 앱스토어 배포
<img src = "https://user-images.githubusercontent.com/84059338/221385210-61312033-a2f6-4489-8c83-c19b1d3e121a.jpeg" alt="https://apps.apple.com/kr/app/%ED%95%B4%EC%88%99%EC%9D%B4%EC%99%80-%EC%82%B0%EC%B1%85/id1621105018" width="120">
<a href="https://apps.apple.com/kr/app/%ED%95%B4%EC%88%99%EC%9D%B4%EC%99%80-%EC%82%B0%EC%B1%85/id1621105018">해숙이와 산책</a>
<br/>

### 사용기술
* SwiftUI
* Combine
* CLLocation
* AVKit
* Firestore
* 네이버 지도 SDK
* Kingfisher
* SwiftLint
<br/>

마커 이미지 저작권
<a href="https://www.flaticon.com/kr/premium-icon/veterinarian_5695709?term=%EB%A7%88%EC%BB%A4&related_id=5695709">수의사 아이콘  제작자: juicy_fish - Flaticon</a>
