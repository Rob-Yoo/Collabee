//
//  DefaultWorkspaceMemberRepository.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine

import DataSource
import Common

public final class DefaultWorkspaceMemberRepository: WorkspaceMemberRepository {
    
    @Injected private var networkProvider: NetworkProvider
    private var cancellable = Set<AnyCancellable>()

    public init() {}
    
    public func invite(_ workspaceID: String, _ body: InviteBody) -> AnyPublisher<Member, WorkspaceMemberError> {
        
        return Future<Member, WorkspaceMemberError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider.request(WorkspaceMemeberAPI.invite(workspaceID, body), MemberDTO.self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        promise(.failure(.inviteFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.toDomain()))
                }
                .store(in: &self.cancellable)
            
        }.eraseToAnyPublisher()
        
    }
    
    public func fetchMemberList(_ workspaceID: String) -> AnyPublisher<[Member], WorkspaceMemberError> {
        
        return Future<[Member], WorkspaceMemberError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider.request(WorkspaceMemeberAPI.memberList(workspaceID), [MemberDTO].self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        promise(.failure(.loadFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.map { $0.toDomain() }))
                }
                .store(in: &self.cancellable)
            
        }.eraseToAnyPublisher()
        
    }
    
    public func fetchMemberDetail(_ workspaceID: String, _ userID: String) -> AnyPublisher<Member, WorkspaceMemberError> {
        
        return Future<Member, WorkspaceMemberError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider.request(WorkspaceMemeberAPI.memberInfo(workspaceID, userID), MemberDTO.self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        promise(.failure(.loadFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.toDomain()))
                }
                .store(in: &self.cancellable)
            
        }.eraseToAnyPublisher()
        
    }

}
