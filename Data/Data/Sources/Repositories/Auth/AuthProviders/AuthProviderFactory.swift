//
//  AuthProviderFactory.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/5/24.
//

import Domain

enum AuthProviderFactory {
    
    static func createAuthProvider(_ type: AuthProviderType) -> AuthProvider {
        switch type {
        case .kakao:
            return KakaoOAuth()
        case .apple(let presentationAnchor):
            return AppleOAuth(presentationAnchor: presentationAnchor)
        @unknown default:
            fatalError("아직 제공하지 않는 AuthProvider")
        }
    }
}
