//
//  CustomInfoWindowDataSource.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/25.
//

import NMapsMap

class CustomInfoWindowView: NSObject, NMFOverlayImageDataSource {
  enum Status {
    case selected
    case normal
  }
  
  let title: String
  let status: Status
  
  init(title: String, status: Status = .normal) {
    self.title = title
    self.status = status
  }
  
  func view(with overlay: NMFOverlay) -> UIView {
    let label: UILabel = {
      let label = UILabel()
      label.text = self.title
      label.textAlignment = .center
      let labelSize = label.intrinsicContentSize
      let backgroundHeight = labelSize.height + 5
      let backgroundWidth = labelSize.width + backgroundHeight
      label.frame = CGRect(x: 0, y: 0,
                           width: backgroundWidth,
                           height: backgroundHeight)
      label.layer.cornerRadius = backgroundHeight / 2
      label.layer.borderWidth = 0.5
      label.layer.borderColor = UIColor.black.cgColor
      label.clipsToBounds = true
      
      if status == .normal {
        label.backgroundColor = .white
        label.textColor = .black
      } else {
        label.backgroundColor = .systemBlue
        label.textColor = .white
      }
      return label
    }()
    return label
  }
}
