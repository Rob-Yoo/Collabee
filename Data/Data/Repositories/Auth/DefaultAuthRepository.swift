//
//  DefaultAuthRepository.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/5/24.
//

import Domain

public final class DefaultAuthRepository: AuthRepository {
    
    private var authProvider: AuthProvider!
    
    public func login(_ providerType: AuthProviderType) {
        self.authProvider = AuthProviderFactory.createAuthProvider(providerType)
        authProvider.login()
    }
    
    public func handleOpenURL(_ url: URL) {
        authProvider.handleOpenURL?(url)
    }
}
