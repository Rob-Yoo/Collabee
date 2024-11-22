//
//  KakaoAuthService.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

import DataSource
import Common

final class KakaoAuthService: AuthService {
    
    @Injected private var networkProvider: NetworkProvider
    private var cancellable = Set<AnyCancellable>()

    public init() {
        let kakaoAppKey = Literal.Secret.KakaoNativeKey ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }
    
    func perform() -> AnyPublisher<Void, AuthorizationError> {
        return Future<Void, AuthorizationError> { [weak self] promise in
            guard let self else { return }
            
            self.kakaoLogin()
                .mapError { _ in NetworkError.unknownError }
                .flatMap { loginBody -> AnyPublisher<LoginResult, NetworkError> in
                    
                    return self.networkProvider.request(UserAPI.kakaoLogin(loginBody), LoginResult.self, .withoutToken)
                }
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(.loginFailure))
                    }
                } receiveValue: { res in
                    let token = res.token
                    
                    TokenStorage.save(token.accessToken, .access)
                    TokenStorage.save(token.refreshToken, .refresh)
                    promise(.success(()))
                }
                .store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    func handleOpenURL(_ url: URL) {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
    
    private func kakaoLogin() -> AnyPublisher<KakaoLoginBody, Error> {
            
        return Future<KakaoLoginBody, Error> { promise in
            
            let completion: (OAuthToken?, (any Error)?) -> Void = { (token, error) in
                if let error {
                    promise(.failure(error))
                }
                
                if let token {
                    let loginBody = KakaoLoginBody(oauthToken: token.accessToken)
                    promise(.success(loginBody))
                }
            }
            
            UserApi.isKakaoTalkLoginAvailable() ?  UserApi.shared.loginWithKakaoTalk(completion: completion) : UserApi.shared.loginWithKakaoAccount(completion: completion)
            
        }.eraseToAnyPublisher()
    }
}
