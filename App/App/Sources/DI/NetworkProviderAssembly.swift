//
//  NetworkProviderAssembly.swift
//  App
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import DataSource
import Common

struct NetworkProviderAssembly: Assembly {
    func assemble(container: Common.Container) {
        container.register(NetworkProvider.self) { _ in
            return DefaultNetworkProvider()
        }
    }
}
