//
//  KakaoAuthService.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/12/24.
//

import Combine

import Domain

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class KakaoAuthService: AuthService {
    
    private let networkProvider: NetworkProvider
    private var cancellable = Set<AnyCancellable>()

    public init(networkProvider: NetworkProvider = DefaultNetworkProvider.shared) {
        let kakaoAppKey = Literal.Secret.KakaoNativeKey ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        self.networkProvider = networkProvider
    }
    
    func perform() {
        kakaoLogin()
    }
    
    func handleOpenURL(_ url: URL) {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
    
    private func kakaoLogin() -> AnyPublisher<LoginBody, Error> {
            
        return Future<LoginBody, Error> { promise in
            
            let completion: (OAuthToken?, (any Error)?) -> Void = { (token, error) in
                if let error {
                    promise(.failure(error))
                }
                
                if let token, let idToken = token.idToken {
                    let loginBody = LoginBody(idToken: idToken)
                    promise(.success(loginBody))
                }
            }
            
            UserApi.isKakaoTalkLoginAvailable() ?  UserApi.shared.loginWithKakaoTalk(completion: completion) : UserApi.shared.loginWithKakaoAccount(completion: completion)
            
        }.eraseToAnyPublisher()
    }
}
