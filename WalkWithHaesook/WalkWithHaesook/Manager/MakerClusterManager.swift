//
//  ClusterManager.swift
//  WalkWithHaesook
//
//  Created by linkey on 2022/10/27.
//

import Foundation
import NMapsMap

class MakerClusterManager {
  func getCluster(makers: [NMFMarker], basePosition: NMGLatLng, allowableDistance: Double, completionHandler: @escaping ([MakerClusterModel], [[NMFMarker]]) -> Void) {
    guard makers.count > 1 else { return }
    var centers = getFirstCenters(makers: makers, basePosition: basePosition, allowableDistance: allowableDistance)
    var cluster: [[NMFMarker]] = []
    var centerMoveDistance: Double = 0.0
    
    repeat {
      var classification: [[NMFMarker]] = .init(repeating: [], count: centers.count)
      makers.forEach {
        if let nearIndex =
                indexOfNearestCenter(
                  baseMaker: $0,
                  centers: centers,
                  allowableDistance: allowableDistance
                ) {
          classification[nearIndex].append($0)
        }
      }
      let newCenters = classification.map { assignedPoints -> NMFMarker in
        calculateCenters(makers: assignedPoints)
      }
      centerMoveDistance = 0.0
      for index in 0..<centers.count {
        centerMoveDistance +=
        centers[index].position.distance(to: newCenters[index].position)
      }
      centers = newCenters
      cluster = classification
    } while centerMoveDistance > 0
    
    let convertedTypeCenters = centers.enumerated().map { (index, center) -> MakerClusterModel in
        MakerClusterModel(
          centroid: center.position,
          infoWindow: NMFInfoWindow(),
          makerCount: cluster[index].count,
          circle: NMFCircleOverlay())
    }.filter { $0.makerCount > 1 }
    
    completionHandler(
      convertedTypeCenters,
      cluster.filter { $0.count > 1 }
    )
  }
  
  private func getFirstCenters(
    makers: [NMFMarker],
    basePosition: NMGLatLng,
    allowableDistance: Double
  ) -> [NMFMarker] {
    var doubleArray: [[NMFMarker]] = []
    var sortedMakers = makers.sorted {
      basePosition.distance(to: $0.position) < basePosition.distance(to: $1.position)
    }
    while sortedMakers.isEmpty == false {
      var baseMaker: NMFMarker?
      var nearestMaker: [NMFMarker] = []
      sortedMakers.forEach {
        if baseMaker == nil {
          baseMaker = $0
        }
        guard let baseMaker = baseMaker else { return }
        let distance = baseMaker.position.distance(to: $0.position)
        if distance <= allowableDistance {
          nearestMaker.append($0)
        }
        if nearestMaker.contains($0),
           let deleteIndex = sortedMakers.firstIndex(of: $0) {
          sortedMakers.remove(at: deleteIndex)
        }
      }
      doubleArray.append(nearestMaker)
    }
    var result: [NMFMarker] = []
    doubleArray.filter { $0.count > 1 }
      .forEach { makers in
        let center = calculateCenters(makers: makers)
        result.append(center)
      }
    return result
  }
  
  private func calculateCenters(makers: [NMFMarker]) -> NMFMarker {
    let centerLat = makers.reduce(0) { result, maker in
      result + (maker.position.lat)
    } / Double(makers.count)
    let centerLng = makers.reduce(0) { result, maker in
      result + (maker.position.lng)
    } / Double(makers.count)
    return NMFMarker(position: NMGLatLng(lat: centerLat, lng: centerLng))
  }
  
  private func indexOfNearestCenter(
    baseMaker: NMFMarker,
    centers: [NMFMarker],
    allowableDistance: Double
  ) -> Int? {
    var minIndex: Int?
    centers.enumerated().forEach { index, center in
      let distance = baseMaker.position.distance(to: center.position)
      if distance < allowableDistance {
        minIndex = index
      }
    }
    return minIndex
  }
}
