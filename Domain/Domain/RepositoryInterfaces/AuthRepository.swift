//
//  AuthRepository.swift
//  Domain
//
//  Created by Jinyoung Yoo on 11/5/24.
//

public protocol AuthRepository {
    func login(_ providerType: AuthProviderType)
    func handleOpenURL(_ url: URL)
}
