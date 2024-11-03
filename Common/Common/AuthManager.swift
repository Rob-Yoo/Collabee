//
//  AuthManager.swift
//  Common
//
//  Created by Jinyoung Yoo on 11/3/24.
//

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

public protocol OAuthProvider {
    func login()
    func handleOpenURL(_ url: URL)
}

public final class AuthManager {
    
    static public let shared = AuthManager()
    private var oauthProivder: OAuthProvider!
    
    private init() {}
    
    public func login(_ provider: OAuthProvider) {
        self.oauthProivder = provider
        oauthProivder.login()
    }
    
    public func handleOpenURL(_ url: URL) {
        oauthProivder.handleOpenURL(url)
    }
}

public final class KakaoOAuth: OAuthProvider {

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
                        print("loginWithKakaoAccount() success.")
                        _ = oauthToken
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
    

