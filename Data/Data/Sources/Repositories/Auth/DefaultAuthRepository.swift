//
//  DefaultAuthRepository.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/12/24.
//

import Combine

import Domain

public final class DefaultAuthRepository: AuthRepository {
    
    private var authService: AuthService!
    
    public init() {}
    
    public func login(_ authType: AuthType) -> AnyPublisher<Void, Error> {
//        authService = AuthServiceFactory.create(authType)
    }
    
    public func handleOpenURL(_ url: URL) {
        authService.handleOpenURL(url)
    }
}
