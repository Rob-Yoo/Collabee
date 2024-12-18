//
//  TokenStorage.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/8/24.
//

import Foundation
import Combine

import Common

public enum TokenStorage {

    private static let keyChain = KeyChain.shared
    @Injected private static var tokenProvider: NetworkProvider
    private static var cancellables = Set<AnyCancellable>()
    
    public enum TokenType: String, CaseIterable {
        case access
        case refresh
    }
    
    public static func save(_ token: String, _ tokenType: TokenType
    ) {
        if (tokenType == .access) {
            print("액세스 토큰: \(token)")
        } else {
            print("리프레시 토큰: \(token)")
        }
        keyChain.save(token.data(using: .utf8)!, account: tokenType.rawValue)
    }
    
    public static func read(_ tokenType: TokenType) -> String? {
        guard let tokenData = keyChain.read(account: tokenType.rawValue) else {
            return nil
        }
        
        return String(data: tokenData, encoding: .utf8)
    }
    
    public static func deleteAll() {
        TokenType.allCases.forEach {
            keyChain.delete(account: $0.rawValue)
        }
        
    }
    
    public static func delete(_ tokenType: TokenType) {
        keyChain.delete(account: tokenType.rawValue)
    }
    
    public static func refresh(completionHandler: ((NetworkError?) -> Void)? = nil) {
        guard let refreshToken = read(.refresh) else {
            completionHandler?(NetworkError.unknownError)
            return
        }

        tokenProvider.request(AuthAPI.tokenRefresh(refreshToken), TokenRefresh.self, .withoutToken)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    if let errorCode = error.errorCode, errorCode == "E06" {
                        UserDefaultsStorage.isAuthorized = false
                        delete(.refresh)
                        NotificationCenter.default.post(name: .ChangeWindowScene, object: nil)
                    }
                    
                    print(#function, error.errorDescription ?? "")
                    completionHandler?(error)
                }
            } receiveValue: { tokenRefresh in
                print(#function, "재발급 토큰: " + tokenRefresh.accessToken)
                save(tokenRefresh.accessToken, .access)
                completionHandler?(nil)
            }.store(in: &cancellables)
    }
}
