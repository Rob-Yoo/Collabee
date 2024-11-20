//
//  AuthRepository.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import Combine

public protocol AuthRepository {
    func login(_ authType: AuthType) -> AnyPublisher<Void, AuthorizationError>
    func handleOpenURL(_ url: URL)
}
