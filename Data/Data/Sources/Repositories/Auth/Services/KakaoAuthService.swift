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
    
    func perform() -> AnyPublisher<Void, CollabeeError> {
        return Future<Void, CollabeeError> { [weak self] promise in
            guard let self else { return }
            
            self.kakaoLogin()
                .mapError { _ in CollabeeError.unknownError }
                .flatMap { loginBody -> AnyPublisher<LoginResult, CollabeeError> in
                    
                    return self.networkProvider.request(UserAPI.kakaoLogin(loginBody), LoginResult.self)
                }
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(error))
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
