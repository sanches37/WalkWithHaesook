//
//  KMeans.swift
//  WalkWithHaesook
//
//  Created by linkey on 2022/10/21.
//

import Foundation
import NMapsMap

class KMeans {
  private(set) var centroids: [NMFMarker] = []
  //
  //  init() {
  //    assert(makers.count > 1, "배열의 수가 1보다 작습니다.")
  //    self.makers = makers
  //    self.k = makers.count
  //  }
  
  private func chooseCentroids(_ makers: [NMFMarker], k: Int) {
    var mindistances = [Double](repeating: Double.infinity, count: makers.count)
    var centerIndices: [Int] = []
    let bounds = NMGBounds()

    let firstCenter = makers.randomElement()
    for clusterID in 0..<k {
      var pointIndex: Int
      if clusterID == 0 {
        pointIndex = Int.random(in: 0..<k)
      } else {
        
      }
    }
  }
  
  private func randomCenters(_ makers: [NMFMarker], k: Int) -> [NMFMarker] {
    var result: [NMFMarker] = []
    
    for index in 0..<k {
      result.append(makers[index])
    }
    
    for index in k..<makers.count {
      let randomIndex = Int(arc4random_uniform(UInt32(index + 1)))
      if randomIndex < k {
        result[randomIndex] = makers[index]
      }
    }
    return result
  }
  
  private func indexOfNearestCenter(_ x: NMFMarker, randomCenters: [NMFMarker]) -> Int {
    var nearestDistance = Double.greatestFiniteMagnitude
    var minIndex = 0
    
    randomCenters.enumerated().forEach { index, randomCenter in
      let distance = x.position.distance(to: randomCenter.position)
      if distance < nearestDistance {
        minIndex = index
        nearestDistance = distance
      }
    }
    return minIndex
  }
  
  func getCentroids(
    k: Int,
    makers: [NMFMarker],
    allowableDistance: Double,
    completionHandler: @escaping ([NMFMarker]) -> Void) {
      guard makers.count > 1 else { return }
      var number = k
      
      if makers.count < number {
        number = 1
      }
      var centers = randomCenters(makers, k: number)
      var centerMoveDistance: Double = 0.0
      
      repeat {
        var classification: [[NMFMarker]] = .init(repeating: [], count: number)
        
        makers.forEach { maker in
          let nearIndex = indexOfNearestCenter(maker, randomCenters: centers)
          classification[nearIndex].append(maker)
        }
        
        let newCenters = classification.map { assignedPoints -> NMFMarker in
          let centerLat = assignedPoints.reduce(0) { result, maker in
            result + (maker.position.lat)
          } / Double(assignedPoints.count)
          let centerLng = assignedPoints.reduce(0) { result, maker in
            result + (maker.position.lng)
          } / Double(assignedPoints.count)
          let centerLatLng = NMGLatLng(lat: centerLat, lng: centerLng)
          return NMFMarker(position: centerLatLng)
        }
        centerMoveDistance = 0.0
        for index in 0..<number {
          centerMoveDistance += centers[index].position.distance(to: newCenters[index].position)
        }
        centers = newCenters
      } while centerMoveDistance > allowableDistance
      
      centroids = centers
      completionHandler(centroids)
    }
}
