//
//  AuthServiceFactory.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/24/24.
//

import Combine

protocol AuthService {
    func perform() -> AnyPublisher<Void, AuthorizationError>
    func handleOpenURL(_ url: URL)
}

enum AuthServiceFactory {
    static func create(_ authType: AuthType) -> AuthService {
        switch authType {
        case .kakao:
            return KakaoAuthService()
        case .apple(let presentationAnchor):
            return AppleAuthService(presentationAnchor: presentationAnchor)
        case .email:
            return EmailAuthService()
        }
    }
}
