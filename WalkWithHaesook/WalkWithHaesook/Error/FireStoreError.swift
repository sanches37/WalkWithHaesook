//
//  FireStoreError.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/28.
//

import Foundation

enum FireStoreError: Error, LocalizedError {
    case unknown(description: String)
    case dataNotfound
    case decodingFailed
    
    var errorDescription: String {
        switch self {
        case .unknown(description: let description):
            return "에러: \(description)"
        case .dataNotfound:
            return "전달 받을 데이터가 없습니다."
        case .decodingFailed:
            return "디코딩에 실패했습니다."
        }
    }
}
