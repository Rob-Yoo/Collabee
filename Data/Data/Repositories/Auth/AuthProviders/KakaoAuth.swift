//
//  KakaoAuth.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/5/24.
//

import Domain

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class KakaoOAuth: AuthProvider {

    public init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_KEY"] ?? ""
        print(kakaoAppKey)
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
    }
    
    public func login() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print(oauthToken)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                         print(oauthToken)
                    }
                }
        }
    }
    
    public func handleOpenURL(_ url: URL) {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
}
