//
//  TokenStorage.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/8/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

enum TokenStorage {

    private static let keyChain = KeyChain.shared
    private static let tokenProvider = MoyaProvider<AuthAPI>()
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
    
    static func refresh(completionHandler: @escaping () -> Void) {
        let refreshToken = Self.read(.refresh) ?? ""

        tokenProvider.requestPublisher(.tokenRefresh(refreshToken))
            .sink { completion in
                switch completion {
                case .finished:
                    completionHandler()
                case .failure(let error):
                    guard let res = error.response, let decodeError = try? JSONDecoder().decode(CollabeeError.self, from: res.data) else {
                        print(#function, "CollabeeError 변환 실패")
                        return
                    }
                    if let errorCode = decodeError.errorCode, errorCode == "E06" {
                        // 로그인 화면으로 돌아가야함!!
                    }
                    print(error.errorDescription ?? "")
                }
            } receiveValue: { res in
                if let decodedData = try? JSONDecoder().decode(TokenRefresh.self, from: res.data) {
                    Self.save(decodedData.accessToken, .access)
                }
            }.store(in: &cancellables)

    }
}
