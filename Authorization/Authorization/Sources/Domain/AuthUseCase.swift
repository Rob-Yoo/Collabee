//
//  AuthUseCase.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import Combine
import AuthenticationServices

public enum AuthType {
    case kakao
    case apple(_ presentationAnchor: ASPresentationAnchor)
}

public protocol AuthUseCase {
    func login(_ providerType: AuthType) -> AnyPublisher<Void, AuthorizationError>
    func handleOpenURL(_ url: URL)
}

public final class DefaultAuthUseCase: AuthUseCase {
    
    private var authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func login(_ providerType: AuthType) -> AnyPublisher<Void, AuthorizationError> {
        authRepository.login(providerType)
    }
    
    public func handleOpenURL(_ url: URL) {
        authRepository.handleOpenURL(url)
    }
    
}
