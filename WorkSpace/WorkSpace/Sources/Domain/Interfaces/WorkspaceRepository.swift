//
//  WorkspaceRepository.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Combine

public protocol WorkspaceRepository {
    func create(_ body: CreateWorkspaceBody) -> AnyPublisher<Workspace, WorkspaceError>
    func fetchWorkSpace(_ workspaceID: String) -> AnyPublisher<Workspace, WorkspaceError>
    func edit(_ id: String, _ body: EditWorkspaceBody) -> AnyPublisher<Workspace, WorkspaceError>
    func getWorkspaceID() -> String?
    func saveWorkspaceID(_ id: String)
}
