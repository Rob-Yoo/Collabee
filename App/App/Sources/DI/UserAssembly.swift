//
//  UserAssembly.swift
//  App
//
//  Created by Jinyoung Yoo on 12/6/24.
//

import User
import Common

struct UserAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserRepository.self) { _ in
            return DefaultUserRepository()
        }
    }
}
