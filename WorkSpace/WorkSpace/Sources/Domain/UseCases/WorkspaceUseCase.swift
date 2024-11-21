//
//  WorkspaceUseCase.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Combine

//public protocol WorkspaceUseCase {
//    func create(_ body: CreateWorkspaceBody) -> AnyPublisher<Workspace, WorkspaceError>
//    func get() -> AnyPublisher<Workspace, WorkspaceError>
//    func edit(_ id: String, _ body: EditWorkspaceBody) -> AnyPublisher<Workspace, WorkspaceError>
//}
//
//public final class DefaultWorkspaceUseCase: WorkspaceUseCase {
//    
//    private let repository: WorkspaceRepository
//    
//    init(repository: WorkspaceRepository) {
//        self.repository = repository
//    }
//    
//    public func create(_ body: CreateWorkspaceBody) -> AnyPublisher<Workspace, WorkspaceError> {
//        return repository.create(body)
//    }
//    
//    public func get() -> AnyPublisher<Workspace, WorkspaceError> {
//        return repository.fetchWorkSpace()
//    }
//    
//    public func edit(_ id: String, _ body: EditWorkspaceBody) -> AnyPublisher<Workspace, WorkspaceError> {
//        return repository.edit(id, body)
//    }
//    
//}
