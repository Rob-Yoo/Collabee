//
//  DefaultWorkspaceRepository.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Combine

import DataSource
import Common

public final class DefaultWorkspaceRepository: WorkspaceRepository {
    
    @Injected private var networkProvider: NetworkProvider
    private var cancellable = Set<AnyCancellable>()
    
    public init() {}
    
    public func create(_ body: CreateWorkspaceBody) -> AnyPublisher<Workspace, WorkspaceError> {
        
        return Future<Workspace, WorkspaceError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider
                .request(WorkSpaceAPI.createWorkSpace(body), WorkspaceDTO.self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        print(#function, error.errorDescription ?? "")
                        promise(.failure(.creationFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.toDomain()))
                }
                .store(in: &cancellable)
            
        }.eraseToAnyPublisher()
    }
    
    public func fetchWorkspaceList() -> AnyPublisher<[Workspace], WorkspaceError> {
        return Future<[Workspace], WorkspaceError> { [weak self] promise in

            guard let self else { return }
            
            networkProvider.request(WorkSpaceAPI.workspaceList, [WorkspaceDTO].self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(.getListFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.map { $0.toDomain() }))
                }.store(in: &cancellable)

            
        }.eraseToAnyPublisher()
    }
    
    public func fetchWorkSpace(_ workspaceID: String) -> AnyPublisher<Workspace, WorkspaceError> {
        return Future<Workspace, WorkspaceError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider
                .request(WorkSpaceAPI.workspace(workspaceID), WorkspaceDTO.self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        promise(.failure(.getWorkspaceFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.toDomain()))
                }
                .store(in: &cancellable)
            
        }.eraseToAnyPublisher()
    }
    
    public func edit(_ id: String, _ body: EditWorkspaceBody) -> AnyPublisher<Workspace, WorkspaceError> {
        return Future<Workspace, WorkspaceError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider
                .request(WorkSpaceAPI.editWorkSpace(id, body), WorkspaceDTO.self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        promise(.failure(.creationFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.toDomain()))
                }
                .store(in: &cancellable)
            
        }.eraseToAnyPublisher()
    }
    
    public func getWorkspaceID() -> String? {
        return UserDefaultsStorage.workspaceID
    }
    
    public func saveWorkspaceID(_ id: String) {
        UserDefaultsStorage.workspaceID = id
    }
}
