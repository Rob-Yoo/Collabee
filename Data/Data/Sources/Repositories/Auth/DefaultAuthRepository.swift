//
//  DefaultAuthRepository.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/12/24.
//

import Combine

import Common

public final class DefaultAuthRepository: AuthRepository {
    
    private var authService: AuthService!
    private var cancellable = Set<AnyCancellable>()
    
    public init() {}
    
    public func login(_ authType: AuthType) -> AnyPublisher<Void, Error> {
        authService = AuthServiceFactory.create(authType)
        
        return Future<Void, Error> { [weak self] promise in
            
            guard let self else { return }
            
            authService.perform()
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(error as Error))
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
