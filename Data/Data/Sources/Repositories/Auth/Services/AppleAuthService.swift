//
//  AppleAuthService.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/15/24.
//

import Combine
import AuthenticationServices

import DataSource

final class AppleAuthService: NSObject, AuthService,  ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var networkProvider: NetworkProvider
    private var presentationAnchor: ASPresentationAnchor
    private var loginSubject = PassthroughSubject<AppleLoginBody, Error>()
    private var cancellable = Set<AnyCancellable>()
    
    init(
        presentationAnchor: ASPresentationAnchor,
        networkProvider: NetworkProvider = DefaultNetworkProvider.shared
    ) {
        self.presentationAnchor = presentationAnchor
        self.networkProvider = networkProvider
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationAnchor
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let fullName = appleIDCredential.fullName
            let familyName = fullName?.familyName ?? ""
            let givenName = fullName?.givenName ?? ""
            let nickName = familyName + givenName
            
            if  let identityToken = appleIDCredential.identityToken,
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                let appleLoginBody = AppleLoginBody(idToken: identifyTokenString, nickname: nickName)
                loginSubject.send(appleLoginBody)
                loginSubject.send(completion: .finished)
            } else {
                loginSubject.send(completion: .failure(OAuthError.tokenError))
            }
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        loginSubject.send(completion: .failure(error))
    }
    
    func perform() -> AnyPublisher<Void, CollabeeError> {
        return Future<Void, CollabeeError> { [weak self] promise in
            guard let self else { return }
            
            self.appleLogin()
                .mapError { _ in CollabeeError.unknownError }
                .flatMap { loginBody -> AnyPublisher<LoginResult, CollabeeError> in
                    
                    return self.networkProvider.request(UserAPI.appleLogin(loginBody), LoginResult.self)
                }
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(error))
                    }
                } receiveValue: { res in
                    let token = res.token
                    
                    TokenStorage.save(token.accessToken, .access)
                    TokenStorage.save(token.refreshToken, .refresh)
                    promise(.success(()))
                }
                .store(in: &cancellable)
        }.eraseToAnyPublisher()
    }
    
    private func appleLogin() -> AnyPublisher<AppleLoginBody, Error> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        return loginSubject.eraseToAnyPublisher()
    }
    
    func handleOpenURL(_ url: URL) {}
}

