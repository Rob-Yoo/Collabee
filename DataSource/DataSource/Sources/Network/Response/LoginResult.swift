//
//  LoginResultDTO.swift
//  Data
//
//  Created by Jinyoung Yoo on 11/7/24.
//

import Foundation

public struct LoginResult: Decodable {
    public let token: Token
    
    public init(token: Token) {
        self.token = token
    }
}

public struct Token: Decodable {
    public let accessToken: String
    public let refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
