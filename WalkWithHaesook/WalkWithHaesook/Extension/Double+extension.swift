//
//  Double+extension.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/03/26.
//

import Foundation

extension Double {
  var withMeter: String {
    let formatter = LengthFormatter()
    formatter.numberFormatter.maximumFractionDigits = 2
    
    if self >= 1000 {
      return formatter.string(fromValue: self / 1000, unit: LengthFormatter.Unit.kilometer)
    } else {
      let value = Double(Int(self))
      return formatter.string(fromValue: value, unit: LengthFormatter.Unit.meter)
    }
  }
}
