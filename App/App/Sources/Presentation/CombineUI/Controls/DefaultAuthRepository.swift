//
//  DefaultAuthRepository.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine

import DataSource

public final class DefaultAuthRepository: AuthRepository {
    
    private var authService: AuthService!
    private var cancellable = Set<AnyCancellable>()
    
    public init() {}
    
    public func login(_ authType: AuthType) -> AnyPublisher<Void, AuthorizationError> {
        authService = AuthServiceFactory.create(authType)
        
        return Future<Void, AuthorizationError> { [weak self] promise in
            
            guard let self else { return }
            
            authService.perform()
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(_):
                        promise(.failure(.loginFailure))
                    }
                } receiveValue: { val in
                    UserDefaultsStorage.isAuthorized = true
                    promise(.success(val))
                }.store(in: &cancellable)
            
        }.eraseToAnyPublisher()
    }
    
    public func handleOpenURL(_ url: URL) {
        authService.handleOpenURL(url)
    }
}
