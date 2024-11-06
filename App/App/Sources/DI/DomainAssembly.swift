//
//  DomainAssembly.swift
//  App
//
//  Created by Jinyoung Yoo on 11/6/24.
//

import Domain
import Common

struct DomainAssembly: Assembly {
    func assemble(container: Common.Container) {
        container.register(AuthUseCase.self) { resolver in
            let authRepository = resolver.resolve(AuthRepository.self, objectScope: .shared)
            return DefaultAuthUseCase(authRepository: authRepository)
        }
    }
}
