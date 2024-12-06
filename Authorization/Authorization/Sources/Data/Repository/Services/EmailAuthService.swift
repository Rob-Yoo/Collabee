//
//  EmailAuthService.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/24/24.
//

import Combine

import DataSource
import Common

final class EmailAuthService: AuthService {
    
    @Injected private var networkProvider: NetworkProvider
    private var cancellable = Set<AnyCancellable>()
    
    func perform() -> AnyPublisher<Void, AuthorizationError> {
        
//        let loginBody = EmailLoginBody(email: "user@user.com", password: "Qwer1234!")
        let loginBody = EmailLoginBody(email: "jintest3@test.com", password: "Qwer1234!")
        
        return Future<Void, AuthorizationError> { [weak self] promise in
            
            guard let self else { return }
            
            networkProvider.request(UserAPI.emailLogin(loginBody), LoginResult.self, .withoutToken)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(.loginFailure))
                    }
                } receiveValue: { res in
                    let token = res.token

                    UserDefaultsStorage.userID = res.userID
                    TokenStorage.save(token.accessToken, .access)
                    TokenStorage.save(token.refreshToken, .refresh)
                    promise(.success(()))
                }
                .store(in: &cancellable)
            
        }.eraseToAnyPublisher()
        
    }
    
    func handleOpenURL(_ url: URL) {}
}

