//
//  ClusterWindowView.swift
//  WalkWithHaesook
//
//  Created by linkey on 2022/10/24.
//

import NMapsMap

class ClusterInfoWindowView: NSObject, NMFOverlayImageDataSource {
  let title: String
  
  init(title: String) {
    self.title = title
  }
  
  func view(with overlay: NMFOverlay) -> UIView {
    let label: UILabel = {
      let label = UILabel()
      label.text = self.title
      label.textAlignment = .center
      label.font = label.font.withSize(30)
      let labelSize = label.intrinsicContentSize
      let backgroundSize = labelSize.height + 10
      label.frame =
      CGRect(x: 0, y: 0, width: backgroundSize, height: backgroundSize)
      label.layer.cornerRadius = backgroundSize / 2
      label.layer.borderWidth = 0.5
      label.layer.borderColor = UIColor.black.cgColor
      label.clipsToBounds = true
      label.backgroundColor = .white
      label.textColor = .black
      return label
    }()
    return label
  }
}
