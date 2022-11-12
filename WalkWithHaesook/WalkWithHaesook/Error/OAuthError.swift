//
//  OAuthError.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/11/11.
//

import Foundation

enum OAuthError: Error, LocalizedError {
  case unknown(description: String)
  case tokenLookupFailed
  
  var errorDescription: String {
    switch self {
    case .unknown(description: let description):
      return "에러: \(description)"
    case .tokenLookupFailed:
      return "전달 받을 데이터가 없습니다."
    }
  }
}
