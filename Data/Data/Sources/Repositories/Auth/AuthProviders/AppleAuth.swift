//
//  AppleAuth.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/5/24.
//

import Domain
import AuthenticationServices

final class AppleOAuth: NSObject, AuthProvider,  ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var presentationAnchor: ASPresentationAnchor
    
    public init(presentationAnchor: ASPresentationAnchor) {
        self.presentationAnchor = presentationAnchor
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationAnchor
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let fullName = appleIDCredential.fullName
            let familyName = fullName?.familyName ?? ""
            let givenName = fullName?.givenName ?? ""
            let nickName = familyName + givenName
            
            if  let identityToken = appleIDCredential.identityToken,
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("identifyTokenString: \(identifyTokenString)")
            }

            print("nickname: \(nickName)")
        default:
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print("login failed - \(error.localizedDescription)")
    }
    
    public func login() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
