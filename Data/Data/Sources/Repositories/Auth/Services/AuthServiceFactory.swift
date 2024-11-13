//
//  AuthServiceFactory.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/12/24.
//

import Combine

import Domain

protocol AuthService {
    func perform() -> AnyPublisher<Void, CollabeeError>
    func handleOpenURL(_ url: URL)
}

enum AuthServiceFactory {
    static func create(_ authType: AuthType) -> AuthService {
        switch authType {
        case .kakao:
            return KakaoAuthService()
        case .apple(let presentationAnchor):
            return AppleAuthService(presentationAnchor: presentationAnchor)
        @unknown default:
            fatalError("등록되지 않은 AuthType 사용")
        }
    }
}
