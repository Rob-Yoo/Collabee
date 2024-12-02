//
//  DataSourceAssembly.swift
//  App
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import DataSource
import Common

struct DataSourceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkProvider.self) { _ in
            return DefaultNetworkProvider()
        }
        
        container.register(WebSocketProvider.self) { _ in
            return DefaultWebSocketProvider()
        }
        
        container.register(DataBaseProvider.self) { _ in
            return DefaultDataBaseProvider()
        }
    }
}
