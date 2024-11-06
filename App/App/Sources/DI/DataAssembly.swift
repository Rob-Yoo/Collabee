//
//  DataAssembly.swift
//  App
//
//  Created by Jinyoung Yoo on 11/6/24.
//

import Domain
import Data
import Common

struct DataAssembly: Assembly {
    func assemble(container: Common.Container) {
        container.register(AuthRepository.self) { _ in
            return DefaultAuthRepository()
        }
    }
}
