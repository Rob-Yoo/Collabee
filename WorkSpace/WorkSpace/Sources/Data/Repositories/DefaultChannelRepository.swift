//
//  DefaultChannelRepository.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine

import DataSource
import Common

public final class DefaultChannelRepository: ChannelRepository {
    
    @Injected private var networkProvider: NetworkProvider
    private var cancellable = Set<AnyCancellable>()
    
    public init() {}
    
    public func create(_ workspaceID: String, _ body: ChannelBody) -> AnyPublisher<Channel, ChannelError> {
        
        return Future<Channel, ChannelError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider.request(ChannelAPI.create(workspaceID, body), ChannelDTO.self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        promise(.failure(.creationFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.toDomain()))
                }.store(in: &self.cancellable)
            
        }.eraseToAnyPublisher()

    }
    
    public func fetchAll(_ workspaceID: String) -> AnyPublisher<[Channel], ChannelError> {
        
        return Future<[Channel], ChannelError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider.request(ChannelAPI.channels(workspaceID), [ChannelDTO].self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        promise(.failure(.getListFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.map { $0.toDomain() }))
                }.store(in: &self.cancellable)
            
        }.eraseToAnyPublisher()
    }
    
    public func fetchMyChannels(_ workspaceID: String) -> AnyPublisher<[Channel], ChannelError> {
        
        return Future<[Channel], ChannelError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider.request(ChannelAPI.myChannels(workspaceID), [ChannelDTO].self, .withToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        promise(.failure(.getListFailure))
                    }
                } receiveValue: { res in
                    promise(.success(res.map { $0.toDomain() }))
                }.store(in: &self.cancellable)
            
        }.eraseToAnyPublisher()
        
    }
    
    
}
