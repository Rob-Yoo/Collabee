//
//  AuthorizationAssembly.swift
//  App
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import Authorization
import Common

struct AuthorizationAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(AuthRepository.self) { _ in
            return DefaultAuthRepository()
        }
        
        container.register(AuthUseCase.self) { resolver in
            let authRepository = resolver.resolve(AuthRepository.self, objectScope: .shared)
            return DefaultAuthUseCase(authRepository: authRepository)
        }
    }
}
