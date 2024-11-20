//
//  LoginResult.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

struct LoginResult: Decodable {
    let token: Token
    
    init(token: Token) {
        self.token = token
    }
}

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
