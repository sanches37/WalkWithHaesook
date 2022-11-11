//
//  KakaoAuthManager.swift
//  WalkWithHaesook
//
//  Created by tae hoon park on 2022/11/11.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth

struct KaKaoAuthManager {
  func kakaoLogin() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
        try? self.onReceiveKakaoToken(oAuthToken: oAuthToken, error: error)
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
        try? self.onReceiveKakaoToken(oAuthToken: oAuthToken, error: error)
      }
    }
  }
  
  private func onReceiveKakaoToken(oAuthToken: OAuthToken?, error: Error?) throws {
    if let error = error {
      throw OAuthError.loginFailed(description: error.localizedDescription)
    } else {
      guard let kakaoToken = oAuthToken else {
        throw OAuthError.tokenLookupFailed
      }
      print("카카오톡 로그인 성공: \(kakaoToken)")
    }
  }
}
