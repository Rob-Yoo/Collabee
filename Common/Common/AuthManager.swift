//
//  AuthManager.swift
//  Common
//
//  Created by Jinyoung Yoo on 11/3/24.
//

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

@objc
public protocol OAuthProvider {
    func login()
    @objc optional func handleOpenURL(_ url: URL)
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
        oauthProivder.handleOpenURL?(url)
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

public final class AppleOAuth: NSObject, OAuthProvider,  ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var presentationAnchor: ASPresentationAnchor
    
    public init(presentationAnchor: ASPresentationAnchor) {
        self.presentationAnchor = presentationAnchor
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationAnchor
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName) \(fullName?.givenName) \(fullName?.familyName) \(fullName?.nickname)")
            print("email: \(email)")
            
        default:
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
    
    public func login() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
    

