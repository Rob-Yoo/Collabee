//
//  AppleAuthRepository.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/5/24.
//

import Combine
import AuthenticationServices

import Domain

final class AppleAuthService: NSObject, AuthService,  ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var networkProvider: NetworkProvider
    private var presentationAnchor: ASPresentationAnchor
    private var loginSubject = PassthroughSubject<LoginBody, Error>()
    
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
                let loginBody = LoginBody(idToken: identifyTokenString, nickname: nickName)
                loginSubject.send(loginBody)
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
    
    func perform() {
        
    }
    
    func login() -> AnyPublisher<LoginBody, Error> {
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
