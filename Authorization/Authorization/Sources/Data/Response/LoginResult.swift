//
//  LoginResult.swift
//  Authorization
//
//  Created by Jinyoung Yoo on 11/20/24.
//

import Foundation

struct LoginResult: Decodable {
    let userID: String
    let token: Token
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token
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
