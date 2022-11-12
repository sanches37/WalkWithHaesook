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
  func getKakaoToken(
    completion: @escaping (Result<OAuthToken, OAuthError>) -> Void) {
      guard let getToken = checkedKakaoInstallState() else { return }
      if AuthApi.hasToken() {
        UserApi.shared.logout { error in
          if let error = error {
            completion(
              .failure(
                .unknown(description: error.localizedDescription)
              )
            )
          }
          completion(.success(getToken))
        }
      } else {
        completion(.success(getToken))
      }
    }
  
  private func checkedKakaoInstallState() -> OAuthToken? {
    var result: OAuthToken?
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
        do {
          result = try self.onReceiveKakaoToken(oAuthToken: oAuthToken, error: error)
        } catch {
          debugPrint(error)
        }
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
        do {
          result = try self.onReceiveKakaoToken(oAuthToken: oAuthToken, error: error)
        } catch {
          debugPrint(error)
        }
      }
    }
    return result
  }
  
  private func onReceiveKakaoToken(oAuthToken: OAuthToken?, error: Error?) throws -> OAuthToken {
    if let error = error {
      throw OAuthError.unknown(
        description: error.localizedDescription)
    } else {
      guard let kakaoToken = oAuthToken else {
        throw OAuthError.tokenLookupFailed
      }
      print("카카오톡 로그인 성공: \(kakaoToken)")
      return kakaoToken
    }
  }
}
