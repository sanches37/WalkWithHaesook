//
//  LocationError.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/02/27.
//

import Foundation

enum LocationError: Error, LocalizedError {
    case denied
    
    var errorDescription: String {
        switch self {
        case .denied:
            return "위치 승인이 거부되었습니다."
        }
    }
}
