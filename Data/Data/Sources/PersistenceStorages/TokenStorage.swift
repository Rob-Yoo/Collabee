//
//  TokenStorage.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/8/24.
//

import Foundation
import Combine

import Common

enum TokenStorage {

    private static let keyChain = KeyChain.shared
    private static let tokenProvider = DefaultNetworkProvider.shared
    private static var cancellables = Set<AnyCancellable>()
    
    enum TokenType: String, CaseIterable {
        case access
        case refresh
    }
    
    static func save(_ token: String, _ tokenType: TokenType
    ) {
        keyChain.save(token.data(using: .utf8)!, account: tokenType.rawValue)
    }
    
    static func read(_ tokenType: TokenType) -> String? {
        guard let tokenData = keyChain.read(account: tokenType.rawValue) else {
            return nil
        }
        
        return String(data: tokenData, encoding: .utf8)
    }
    
    static func deleteAll() {
        TokenType.allCases.forEach {
            keyChain.delete(account: $0.rawValue)
        }
        
    }
    
    static func delete(_ tokenType: TokenType) {
        keyChain.delete(account: tokenType.rawValue)
    }
    
    static func refresh(completionHandler: (() -> Void)? = nil) {
        guard let refreshToken = Self.read(.refresh) else { return }
        
        delete(.access)
        tokenProvider.request(AuthAPI.tokenRefresh(refreshToken), TokenRefresh.self)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    if let errorCode = error.errorCode, errorCode == "E06" {
                        UserDefaultsStorage.isAuthorized = false
                        delete(.refresh)
                        NotificationCenter.default.post(name: .ChangeWindowScene, object: nil)
                    }
                }
            } receiveValue: { tokenRefresh in
                save(tokenRefresh.accessToken, .access)
                completionHandler?()
            }.store(in: &cancellables)
    }
}
