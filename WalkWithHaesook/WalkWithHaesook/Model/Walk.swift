//
//  LatLngDummy.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/26.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Walk: Decodable {
  @DocumentID var id: String?
  let title: String
  let latLng: GeoPoint
  let thumnail: String
  let video: String
  let description: String
}

var parkSample: [Walk] = [
  Walk(id: UUID().uuidString, title: "백현체육공원", latLng: GeoPoint(latitude: 36.1864293331, longitude: 128.4784906760), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "둘모아공원", latLng: GeoPoint(latitude: 36.148431, longitude: 128.3165938966), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "다붓소공원", latLng: GeoPoint(latitude: 36.155883, longitude: 128.311526), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "다붓1공원", latLng: GeoPoint(latitude: 36.156392, longitude: 128.314372), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "다붓2공원", latLng: GeoPoint(latitude: 36.1548081316, longitude: 128.314372), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "소공원", latLng: GeoPoint(latitude: 36.1088784495, longitude: 128.3643982818), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "산림문화생태근린공원", latLng: GeoPoint(latitude: 36.1650991521, longitude: 128.4604655345), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "지산샛강생태공원", latLng: GeoPoint(latitude: 36.1357585857, longitude: 128.3518755431), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "도담공원", latLng: GeoPoint(latitude: 36.1410710395, longitude: 128.4230508367), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "선비공원", latLng: GeoPoint(latitude: 36.156353, longitude: 128.435169), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "무지개공원", latLng: GeoPoint(latitude: 36.156482, longitude: 128.438079), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "달빛공원", latLng: GeoPoint(latitude: 36.1428024495, longitude: 128.4229606172), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "솔찬공원", latLng: GeoPoint(latitude: 36.1447154288, longitude: 128.4207216851), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "근린공원38호", latLng: GeoPoint(latitude: 36.15358372, longitude: 128.3489419), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "서울나들공원", latLng: GeoPoint(latitude: 36.15664981, longitude: 128.426117), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "산동물빛공원", latLng: GeoPoint(latitude: 36.15918786, longitude: 128.4303439), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "원당공원", latLng: GeoPoint(latitude: 36.14742092, longitude: 128.425286), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "우항공원", latLng: GeoPoint(latitude: 36.15302879, longitude: 128.4314654), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "이리공원", latLng: GeoPoint(latitude: 36.20777827, longitude: 128.3254036), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "소소공원", latLng: GeoPoint(latitude: 36.08902643, longitude: 128.3902075), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "화개공원", latLng: GeoPoint(latitude: 36.20952278, longitude: 128.3237011), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "양지공원", latLng: GeoPoint(latitude: 36.12561583, longitude: 128.3589071), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "꽃동산공원", latLng: GeoPoint(latitude: 36.13990856, longitude: 128.3452314), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "오태공원", latLng: GeoPoint(latitude: 36.08321216, longitude: 128.3652958), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "통새미공원", latLng: GeoPoint(latitude: 35.59087332, longitude: 129.3604763), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "송내공원", latLng: GeoPoint(latitude: 35.59232858, longitude: 129.3625324), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "청솔공원", latLng: GeoPoint(latitude: 35.58853845, longitude: 129.3700584), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "상방공원", latLng: GeoPoint(latitude: 35.58425629, longitude: 129.368571), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "화봉공원", latLng: GeoPoint(latitude: 35.58943549, longitude: 129.3648249), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "성내어린이공원", latLng: GeoPoint(latitude: 35.52393871, longitude: 129.4016103), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "수동공원", latLng: GeoPoint(latitude: 35.62489541, longitude: 129.3574434), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "우리공원", latLng: GeoPoint(latitude: 35.63174258, longitude: 129.3560799), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "희망공원", latLng: GeoPoint(latitude: 35.63153712, longitude: 129.3535152), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "오뚜기공원", latLng: GeoPoint(latitude: 35.62974926, longitude: 129.3519602), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "해맑은공원", latLng: GeoPoint(latitude: 35.63016398, longitude: 129.3577975), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "으뜸공원", latLng: GeoPoint(latitude: 35.62892516, longitude: 129.3557885), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "종달새공원", latLng: GeoPoint(latitude: 35.62772724, longitude: 129.3532853), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "중산어린이공원", latLng: GeoPoint(latitude: 35.66164585, longitude: 129.3370105), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "매곡산단공원", latLng: GeoPoint(latitude: 35.64347912, longitude: 129.367077), thumnail: "", video: "", description: ""),
  Walk(id: UUID().uuidString, title: "신천어린이공원", latLng: GeoPoint(latitude: 35.64219111, longitude: 129.3493598), thumnail: "", video: "", description: "")
]
