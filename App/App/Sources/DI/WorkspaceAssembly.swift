//
//  WorkspaceAssembly.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import WorkSpace
import Common

struct WorkspaceAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(WorkspaceRepository.self) { _ in
            return DefaultWorkspaceRepository()
        }
        
        container.register(ChannelRepository.self) { _ in
            return DefaultChannelRepository()
        }
        
        container.register(WorkspaceMemberRepository.self) { _ in
            return DefaultWorkspaceMemberRepository()
        }
    }
}
    
