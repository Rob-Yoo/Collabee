//
//  AuthRepository.swift
//  Domain
//
//  Created by Jinyoung Yoo on 11/5/24.
//

import Combine

public protocol AuthRepository {
    func login(_ authType: AuthType) -> AnyPublisher<Void, Error>
    func handleOpenURL(_ url: URL)
}
