//
//  ChatAssembly.swift
//  App
//
//  Created by Jinyoung Yoo on 12/2/24.
//

import Chat
import Common

struct ChatAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ChatActionRepository.self) { _ in
            return DefaultChatActionRepository()
        }
        
        container.register(ChatDataRepository.self) { _ in
            return DefaultChatDataRepository()
        }
        
        container.register(ChatUseCase.self) { _ in
            return DefaultChatUseCase()
        }
    }
}
