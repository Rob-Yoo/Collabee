//
//  AuthUseCase.swift
//  Domain
//
//  Created by Jinyoung Yoo on 11/5/24.
//

import AuthenticationServices

public enum AuthProviderType {
    case kakao
    case apple(_ presentationAnchor: ASPresentationAnchor)
}

public protocol AuthUseCase {
    func login(_ providerType: AuthProviderType)
    func handleOpenURL(_ url: URL)
}

public final class DefaultAuthUseCase: AuthUseCase {
    
    private var authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func login(_ providerType: AuthProviderType) {
        authRepository.login(providerType)
    }
    
    public func handleOpenURL(_ url: URL) {
        authRepository.handleOpenURL(url)
    }
    
}
